output "tfstate_bucket_name" {
  value = module.tfstate_s3_bucket.this_s3_bucket_id
}

output "tfstate_bucket_arn" {
  value = module.tfstate_s3_bucket.this_s3_bucket_arn
}

output "kms_key_arn" {
  value = aws_kms_key.tf_s3_bucket_key.arn
}

output "kms_key_alias" {
  value = aws_kms_alias.kms_key_s3_bucket.name
}