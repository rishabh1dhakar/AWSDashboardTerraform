# Define remote state here
# It is expected that keys: bucket, key, region, kms_key_id are defined with --
terraform {
  backend "s3" {
    encrypt = true
    key     = "terraform-bootstrap/terraform.tfstate"
  }
}
