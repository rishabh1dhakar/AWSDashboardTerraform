locals {
  bucket_name = "st-${local.region_name[var.region]}-${local.account_id}-tfstate-s3"
  account_id  = data.aws_caller_identity.current.account_id
  org_id      = data.aws_organizations_organization.current.id
}

locals {
  region_name = {
    "us-east-1" = "usa" # US East (N. Virginia)
    "us-east-2" = "usa" # US East (Ohio)
    "us-west-1" = "usa" # US West (N. California)
    "us-west-2" = "usa" # US West (Oregon)
    "sa-east-1" = "br"  # South America (São Paulo)
  }
}

locals {
  tags = merge(
    var.tags,
    {
      createdBy = "Terraform"
    }
  )
}