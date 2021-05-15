resource "aws_kinesis_firehose_delivery_stream" "data_lake_stream" {
  name        = local.kinesis_stream_name
  destination = "redshift"
  tags = merge(
    {
      Name = local.kinesis_stream_name
    },
    var.tags
  )

  s3_configuration {
    role_arn        = var.kinesis_firehose_role_arn
    bucket_arn      = "arn:aws:s3:::${var.firehose_to_redshift_s3_bucket_name}"
    buffer_size     = 15
    buffer_interval = 300
    kms_key_arn     = "arn:aws:kms:us-east-1:${var.redshift_aws_account_id}:key/${var.redshift_s3_bucket_kms_key_id}"
    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = aws_cloudwatch_log_group.cw_stream_log_group.name
      log_stream_name = aws_cloudwatch_log_stream.cw_firehose_log_stream.name
    }
  }

  redshift_configuration {
    role_arn        = var.kinesis_firehose_role_arn
    cluster_jdbcurl = var.redshift_cluster_jdbcurl
    username        = var.redshift_username
    password        = var.redshift_password #data.aws_secretsmanager_secret_version.redshift_secret_get.secret_string
    data_table_name = var.redshift_table_name
    copy_options    = "json 's3://${var.firehose_to_redshift_s3_bucket_name}/${var.redshift_table_name}/logs_jsonpath.json'"
    s3_backup_mode  = var.s3_backup_mode


    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = aws_cloudwatch_log_group.cw_stream_log_group.name
      log_stream_name = aws_cloudwatch_log_stream.cw_firehose_log_stream.name
    }
  }
}