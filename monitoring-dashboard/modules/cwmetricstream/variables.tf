variable "region" {
  description = "Provide region in which to deploy"
}

variable "tags" {
  description = "Tags to assign to resources created by this module"
}

variable "kinesis_firehose_role_arn" {
  description = "Provide Kinesis Firehose IAM Role ARN"
}

variable "cloudwatch_metric_stream_role_arn" {
  description = "Provide CloudWatch Metric StreamsIAM Role ARN"
}

variable "firehose_to_redshift_s3_bucket_name" {
  description = "Provide the name of the Intermediate S3 bucket to use"
}

variable "redshift_aws_account_id" {
  description = "Provide the AWS account ID in which the RedShift cluster has been created"
}

variable "redshift_s3_bucket_kms_key_id" {
  description = "Provide the name of the Intermediate S3 bucket to use"
}

variable "redshift_username" {
  description = "RedShift User name for Firehose to use"
}

variable "redshift_password" {
  description = "RedShift username password for Firehose to use"
}

variable "redshift_table_name" {
  description = "RedShift Data table name"
}

variable "redshift_database_name" {
  description = "RedShift Database name"
}

variable "redshift_cluster_jdbcurl" {
  description = "RedShift Cluster JDBC URL"
}

variable "s3_backup_mode" {
  description = "Enable or disable S3 backup"
  default     = "Disabled"
}

variable "kinesis_cw_stream_log_group_name_prefix" {
  description = "CloudWatch Metric / Kinesis Stream Log Group Name prefix"
}