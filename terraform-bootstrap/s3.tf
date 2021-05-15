# -- Terraform state S3 bucket KMS key
resource "aws_kms_key" "tf_s3_bucket_key" {
  description             = "This key is used to encrypt Terraform S3 bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  policy = templatefile("./policies/tf_state_bucket_kms_policy.json",
    {
      account_id = local.account_id
      org_id     = local.org_id
  })

  tags = local.tags

}

resource "aws_kms_alias" "kms_key_s3_bucket" {
  name          = "alias/${local.bucket_name}-kms"
  target_key_id = aws_kms_key.tf_s3_bucket_key.key_id
}

# -- Terraform state S3 bucket
module "tfstate_s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "1.25.0"

  bucket = local.bucket_name
  acl    = "private"

  force_destroy = false
  attach_policy = true
  policy = templatefile("./policies/tf_state_bucket_policy.json",
    {
      bucket_name = local.bucket_name
      account_id  = local.account_id
      org_id      = local.org_id
  })

  tags = local.tags


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
          days          = 60
          storage_class = "ONEZONE_IA"
        }
      ]

      expiration = {
        days = 90
      }

      noncurrent_version_expiration = {
        days = 30
      }
    }
  ]

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = aws_kms_key.tf_s3_bucket_key.arn
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