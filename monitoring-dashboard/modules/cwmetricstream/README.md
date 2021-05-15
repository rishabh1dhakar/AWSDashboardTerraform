### Module for creation of CloudWatch Metric Streams and Kinesis Firehose Delivery Streams

This module is used to create a cloudwatch metric streams and kinesis firehose delivery stream.
* For the module to be in use it needs to have specified path on where the module is situated using "source".
* Configuring the module is straightforward by applying the needed values as per the example below.
### Usage


```hcl

module "cw_metric_stream_us-east-1" {
  source                                  = "./modules/cwmetricstream"     # Path of the module
  firehose_to_redshift_s3_bucket_name     = "firehose_redshift_bucket"
  cloudwatch_metric_stream_role_arn       = aws_iam_role.cw_service_role.arn
  kinesis_firehose_role_arn               = aws_iam_role.firehose_role.arn
  kinesis_cw_stream_log_group_name_prefix = "/aws/kinesisfirehose/cwmetrics/stream"
  redshift_aws_account_id                 = "18196*******"                  # The accound ID where the redshift is running
  redshift_cluster_jdbcurl                = "jdbc:redshift://rst-us-east-1-graphana-monitoring****"
  redshift_database_name                  = "redshift_db_name"
  redshift_password                       = "redshift_db_password"
  redshift_s3_bucket_kms_key_id           = aws_kms_key.kms_key_id_for_s3_bucket.id  # Key ID for s3 bucket
  redshift_table_name                     = "redshift_table_name"
  redshift_username                       = "redshift_username"
  region                                  = "us-east-1"
  tags                                    = var.tags          # The tags defining Name; Environment etc. is using variable, check example below.
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "TEST"
  }
}

```

