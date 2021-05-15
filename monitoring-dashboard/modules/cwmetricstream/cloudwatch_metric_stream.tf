################################################################ Cloudwatch log group and log stream

resource "aws_cloudwatch_log_group" "cw_stream_log_group" {
  name = "${var.kinesis_cw_stream_log_group_name_prefix}/${local.kinesis_stream_name}"
  tags = merge(
    {
      Name = "${var.kinesis_cw_stream_log_group_name_prefix}/${local.kinesis_stream_name}"
    },
    var.tags
  )
}

resource "aws_cloudwatch_log_stream" "cw_firehose_log_stream" {
  log_group_name = aws_cloudwatch_log_group.cw_stream_log_group.name
  name           = "logstream-${local.kinesis_stream_name}"
}

############################################################### Create Cloudwatch Metric Streams
# Based on the following scope defined by client - we include only EC2, RDS and S3
# Availability for EC2 instances;Availability for S3 buckets;High CPU Usage (75% warning; 95% critical)Ability to see if the resource is in Down status;S3 bucket storage consumption – more than 4Tb – critical;RDS - 500GB Warning -> 1TB CriticalMemory consumption (best practice);CPU utilization DiskReadBytesDiskWriteBytesDiskReadOpsDiskWriteOpsNetworkInNetworkOutCPUCreditUsageCPUCreditBalance

resource "null_resource" "cw_metric_streams" {
  triggers = {
    region       = var.region
    name         = local.cloudwatch_metrics_stream_name
    firehose-arn = aws_kinesis_firehose_delivery_stream.data_lake_stream.arn
    role-arn     = var.cloudwatch_metric_stream_role_arn
  }

  provisioner "local-exec" {
    command = <<-COMMANDS
    aws cloudwatch put-metric-stream --name ${local.cloudwatch_metrics_stream_name} --firehose-arn ${aws_kinesis_firehose_delivery_stream.data_lake_stream.arn} --role-arn ${var.cloudwatch_metric_stream_role_arn} --include-filters [{\"Namespace\":\"AWS\/EC2\"},{\"Namespace\":\"AWS\/EBS\"},{\"Namespace\":\"AWS\/RDS\"},{\"Namespace\":\"AWS\/S3\"}]  --output-format "json" --region ${var.region}
    COMMANDS
  }

  provisioner "local-exec" {
    # Handle metric stream recreation
    when    = destroy
    command = <<-COMMANDS
    aws cloudwatch delete-metric-stream --name ${self.triggers.name} --region ${self.triggers.region}
    COMMANDS
  }
}