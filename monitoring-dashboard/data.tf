/*------------------------------------
This file uses the data source option of terraform to dynamically query information directly from AWS,
without the need for hard coding the resources ARNs, IDs and etc. and the value can be directly used
within the resources.
*/


data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_organizations_organization" "current" {}

data "aws_secretsmanager_secret" "redshift_secret_by_arn" {
  #count = var.main_redshift_cluster ? 0 : 1
  arn = "arn:aws:secretsmanager:${var.region}:${var.redshift_aws_account_id}:secret:${var.redshift_secret_name}-${var.redshift_secret_arn_suffix}"
}

data "aws_secretsmanager_secret_version" "redshift_secret_get" {
  #count     = var.main_redshift_cluster ? 0 : 1
  secret_id = data.aws_secretsmanager_secret.redshift_secret_by_arn.id
}

data "aws_vpc" "redshift_vpc" {
  count = var.main_redshift_cluster ? 1 : 0
  filter {
    name   = "tag:Name"
    values = [var.redshift_vpc_name]
  }
}

data "aws_subnet_ids" "redshift_subnets" {
  count  = var.main_redshift_cluster ? 1 : 0
  vpc_id = data.aws_vpc.redshift_vpc[0].id

  filter {
    name   = "tag:Name"
    values = [join("-", [substr(var.redshift_vpc_name, 0, 9), "SS", "*", "Pub", "*"])]
  }
}