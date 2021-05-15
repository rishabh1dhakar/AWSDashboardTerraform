/*
This file tells terraform to store its terraform.tfstate file within a S3 bucket
*/


# Define remote state here
# It is expected that keys: bucket, key, region, kms_key_id are defined with --
terraform {
  backend "s3" {
    encrypt = true
    key     = "monitoring-dashboard/terraform.tfstate"
  }
}
