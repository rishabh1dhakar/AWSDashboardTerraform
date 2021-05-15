/*-------------------------------
This file assigns a local values which are used for certain configurations within a module or a resource,
the local values are like variables but in certain cases more agile as they can use data sources and variables.
*/

locals {
  kinesis_firehose_iam          = "kns-cw-firehose-stream-iam"
  cloudwatch_metrics_stream_iam = "kv-cw-metrics-stream-iam"
  redshift_cluster_name         = "rst-${var.region}-graphana-monitoring-dashboard"
}

locals {
  bucket_name = "st-${local.region_name[var.region]}-${local.account_id}-cw-streams-s3"
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
  # Firehose IP ranges per region
  # https://docs.aws.amazon.com/firehose/latest/dev/controlling-access.html#using-iam-rs-vpc
  firehose_ips_by_region = [
    "13.58.135.96/27",   # for US East (Ohio)
    "52.70.63.192/27",   # for US East (N. Virginia)
    "13.57.135.192/27",  # for US West (N. California)
    "52.89.255.224/27",  # for US West (Oregon)
    "18.253.138.96/27",  # for AWS GovCloud (US-East)
    "52.61.204.160/27",  # for AWS GovCloud (US-West)
    "35.183.92.128/27",  # for Canada (Central)
    "18.162.221.32/27",  # for Asia Pacific (Hong Kong)
    "13.232.67.32/27",   # for Asia Pacific (Mumbai)
    "13.209.1.64/27",    # for Asia Pacific (Seoul)
    "13.228.64.192/27",  # for Asia Pacific (Singapore)
    "13.210.67.224/27",  # for Asia Pacific (Sydney)
    "13.113.196.224/27", # for Asia Pacific (Tokyo)
    "52.81.151.32/27",   # for China (Beijing)
    "161.189.23.64/27",  # for China (Ningxia)
    "35.158.127.160/27", # for Europe (Frankfurt)
    "52.19.239.192/27",  # for Europe (Ireland)
    "18.130.1.96/27",    # for Europe (London)
    "35.180.1.96/27",    # for Europe (Paris)
    "13.53.63.224/27",   # for Europe (Stockholm)
    "15.185.91.0/27",    # for Middle East (Bahrain)
    "18.228.1.128/27",   # for South America (São Paulo)
    "15.161.135.128/27", # for Europe (Milan)
    "13.244.121.224/27", # for Africa (Cape Town)
    "13.208.177.192/27", # for Asia Pacific (Osaka)
  ]
}