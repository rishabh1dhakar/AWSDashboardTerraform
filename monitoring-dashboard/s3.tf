/*
This file uses a module to create a firehose redshift S3 bucket which is used for storing the data from the
CloudWatch metric streams.
*/

# -- Firehose intermediate state S3 bucket
module "firehose_s3_bucket" {
  count   = var.main_redshift_cluster ? 1 : 0
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "1.25.0"

  bucket = local.bucket_name
  acl    = "private"

  force_destroy = false
  attach_policy = true
  policy = templatefile("./policies/firehose_redshift_s3_bucket_policy.json",
    {
      bucket_name = local.bucket_name
      account_id  = local.account_id
      org_id      = local.org_id
  })

  tags = merge(
    {
      Name = local.bucket_name
    },
    var.tags
  )


  versioning = {
    enabled = false
  }

  lifecycle_rule = [
    {
      id      = "transition"
      enabled = true

      tags = {
        rule      = "transition"
        autoclean = "true"
      }

      transition = [
        {
          days          = 90
          storage_class = "ONEZONE_IA"
        }
      ]

      expiration = {
        days = 365
      }

      noncurrent_version_expiration = {
        days = 180
      }
    }
  ]

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = aws_kms_key.redshift_kms_key[0].arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  # S3 bucket-level Public Access Block configuration
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}