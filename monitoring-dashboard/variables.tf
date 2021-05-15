/*----------------------------------
This file defines variables needed for the proper configuration of Redshift, Firehose and CloudWatch
*/

# Any value in here could be overwritten from config.tfvars
variable "region" {
  type    = string
  default = "us-east-1"
}

variable "additional_regions" {
  type = list(any)
  default = [
    "us-east-1",
    "us-east-2",
    "us-west-1",
    "us-west-2",
    "sa-east-1",
    "ca-central-1",
    "eu-central-1",
    "eu-west-1",
    "eu-west-2",
    "eu-west-3",
    "eu-north-1",
    "ap-south-1",
    "ap-southeast-1",
    "ap-southeast-2",
    "ap-northeast-1",
    "ap-northeast-2",
  ]
}


# As we are not using terraform remote state intentionally, as we use the same folder and code for both cluster and bucket creation in main account and firehose creation in the other 40 accounts we need to hardcode some variables
# In case the cluster is re-deployed the following variables have to be updated accordingly, as they are used from the firehose delivery streams in the other 40 accoutns
# !!!!!!!!!!!!!!!!!!BEGIN!!!!!!!!!!!!!!!!!
variable "redshift_vpc_name" {
  description = "The VPC ID/Name of the VPC in which the RedShift cluster will reside"
  default     = "Prod-Virg-SharedServices-01" # ProdSS Shared Services VPC Name
}

variable "redshift_aws_account_id" {
  description = "The AWS Account ID of the account in which the RedShift cluster will reside"
  default     = "181965160294" #ProdSS Account ID
}

variable "firehose_to_redshift_s3_bucket_name" {
  description = "S3 firehose bucket"
  default     = "st-usa-181965160294-cw-streams-s3" #ProdSS S3 bucket
}

variable "redshift_s3_bucket_kms_key_id" {
  description = "S3 firehose KMS Key ID"
  default     = "c394afe4-0f8b-45b1-be71-88831547a235" #ProdSS S3 and Redshift encryption KMS key id
}

variable "redshift_cluster_jdbcurl" {
  description = "Jdb curl destination of the Redshift cluster"
  default     = "jdbc:redshift://rst-us-east-1-graphana-monitoring-dashboard.ctgyfiuituhz.us-east-1.redshift.amazonaws.com:5439/monitoring"
}

variable "redshift_secret_arn_suffix" {
  # in case the secret in the redshift cluster account is recreated, this suffix has to be updated
  description = "Redhisft secret ARN suffix"
  default     = "DXx6oB"
}
# !!!!!!!!!!!!!!!!!!END!!!!!!!!!!!!!!!!!!!!


variable "tags" {
  type = map(string)
  default = {
    createdBy          = "Terraform"
    "costCenter"       = "TBD"
    "department"       = "TBD"
    "Project"          = "TBD"
    "Environment"      = "TBD"
    "businessOwner"    = "TBD"
    "applicationOwner" = "TBD"
    "systemOwner"      = "TBD"
    "operationOwner"   = "TBD"
  }
}

variable "redshift_username" {
  description = "User name"
  default     = "awsfirehose"
}

variable "redshift_table_name" {
  description = "Data table name"
  default     = "cwmetrics"
}

variable "redshift_database_name" {
  description = "RedShift Database name"
  default     = "monitoring"
}

variable "s3_backup_mode" {
  description = "Enable or disable S3 backup"
  default     = "Disabled"
}

variable "main_redshift_cluster" {
  description = "Whether to create a cluster or not"
  type        = bool
  default     = false
}

variable "redshift_secret_name" {
  default = "cwmetrics-redshift-secret"
}

variable "kinesis_cw_stream_log_group_name_prefix" {
  description = "CloudWatch Metric / Kinesis Stream Log Group Name prefix"
  default     = "/aws/kinesisfirehose/cwmetrics/stream"
}
