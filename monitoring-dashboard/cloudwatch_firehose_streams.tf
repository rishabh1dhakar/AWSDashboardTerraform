/*-------------------------------------------
This file is using a module to create CloudWatch metric stream and Kinesis Firehose delivery stream
in 16 different regions and handles the configuration needed for the both CW metric streams and Firehose
by passing values such as Redshift credentials and configuration defined within variables.
In addition the redshift password is queried directly and securely from AWS Secrets Manager.
*/


### US-EAST-1
module "cw_metric_stream_us-east-1" {
  source                                  = "./modules/cwmetricstream"
  firehose_to_redshift_s3_bucket_name     = var.firehose_to_redshift_s3_bucket_name
  cloudwatch_metric_stream_role_arn       = aws_iam_role.cw_service_role.arn
  kinesis_firehose_role_arn               = aws_iam_role.firehose_role.arn
  kinesis_cw_stream_log_group_name_prefix = var.kinesis_cw_stream_log_group_name_prefix
  redshift_aws_account_id                 = var.redshift_aws_account_id
  redshift_cluster_jdbcurl                = var.redshift_cluster_jdbcurl
  redshift_database_name                  = var.redshift_database_name
  redshift_password                       = data.aws_secretsmanager_secret_version.redshift_secret_get.secret_string
  redshift_s3_bucket_kms_key_id           = var.redshift_s3_bucket_kms_key_id
  redshift_table_name                     = var.redshift_table_name
  redshift_username                       = var.redshift_username
  region                                  = var.region
  tags                                    = var.tags
}

### US-WEST-1
module "cw_metric_stream_us-west-1" {
  providers = {
    aws = aws.us-west-1
  }
  source                                  = "./modules/cwmetricstream"
  firehose_to_redshift_s3_bucket_name     = var.firehose_to_redshift_s3_bucket_name
  cloudwatch_metric_stream_role_arn       = aws_iam_role.cw_service_role.arn
  kinesis_firehose_role_arn               = aws_iam_role.firehose_role.arn
  kinesis_cw_stream_log_group_name_prefix = var.kinesis_cw_stream_log_group_name_prefix
  redshift_aws_account_id                 = var.redshift_aws_account_id
  redshift_cluster_jdbcurl                = var.redshift_cluster_jdbcurl
  redshift_database_name                  = var.redshift_database_name
  redshift_password                       = data.aws_secretsmanager_secret_version.redshift_secret_get.secret_string
  redshift_s3_bucket_kms_key_id           = var.redshift_s3_bucket_kms_key_id
  redshift_table_name                     = var.redshift_table_name
  redshift_username                       = var.redshift_username
  region                                  = "us-west-1"
  tags                                    = var.tags
}

### US-EAST-2
module "cw_metric_stream_us-east-2" {
  providers = {
    aws = aws.us-east-2
  }
  source                                  = "./modules/cwmetricstream"
  firehose_to_redshift_s3_bucket_name     = var.firehose_to_redshift_s3_bucket_name
  cloudwatch_metric_stream_role_arn       = aws_iam_role.cw_service_role.arn
  kinesis_firehose_role_arn               = aws_iam_role.firehose_role.arn
  kinesis_cw_stream_log_group_name_prefix = var.kinesis_cw_stream_log_group_name_prefix
  redshift_aws_account_id                 = var.redshift_aws_account_id
  redshift_cluster_jdbcurl                = var.redshift_cluster_jdbcurl
  redshift_database_name                  = var.redshift_database_name
  redshift_password                       = data.aws_secretsmanager_secret_version.redshift_secret_get.secret_string
  redshift_s3_bucket_kms_key_id           = var.redshift_s3_bucket_kms_key_id
  redshift_table_name                     = var.redshift_table_name
  redshift_username                       = var.redshift_username
  region                                  = "us-east-2"
  tags                                    = var.tags
}

### EU-CENTRAL-1
module "cw_metric_stream_eu-central-1" {
  providers = {
    aws = aws.eu-central-1
  }
  source                                  = "./modules/cwmetricstream"
  firehose_to_redshift_s3_bucket_name     = var.firehose_to_redshift_s3_bucket_name
  cloudwatch_metric_stream_role_arn       = aws_iam_role.cw_service_role.arn
  kinesis_firehose_role_arn               = aws_iam_role.firehose_role.arn
  kinesis_cw_stream_log_group_name_prefix = var.kinesis_cw_stream_log_group_name_prefix
  redshift_aws_account_id                 = var.redshift_aws_account_id
  redshift_cluster_jdbcurl                = var.redshift_cluster_jdbcurl
  redshift_database_name                  = var.redshift_database_name
  redshift_password                       = data.aws_secretsmanager_secret_version.redshift_secret_get.secret_string
  redshift_s3_bucket_kms_key_id           = var.redshift_s3_bucket_kms_key_id
  redshift_table_name                     = var.redshift_table_name
  redshift_username                       = var.redshift_username
  region                                  = "eu-central-1"
  tags                                    = var.tags
}

### AP-SOUTH-1
module "cw_metric_stream_ap-south-1" {
  providers = {
    aws = aws.ap-south-1
  }
  source                                  = "./modules/cwmetricstream"
  firehose_to_redshift_s3_bucket_name     = var.firehose_to_redshift_s3_bucket_name
  cloudwatch_metric_stream_role_arn       = aws_iam_role.cw_service_role.arn
  kinesis_firehose_role_arn               = aws_iam_role.firehose_role.arn
  kinesis_cw_stream_log_group_name_prefix = var.kinesis_cw_stream_log_group_name_prefix
  redshift_aws_account_id                 = var.redshift_aws_account_id
  redshift_cluster_jdbcurl                = var.redshift_cluster_jdbcurl
  redshift_database_name                  = var.redshift_database_name
  redshift_password                       = data.aws_secretsmanager_secret_version.redshift_secret_get.secret_string
  redshift_s3_bucket_kms_key_id           = var.redshift_s3_bucket_kms_key_id
  redshift_table_name                     = var.redshift_table_name
  redshift_username                       = var.redshift_username
  region                                  = "ap-south-1"
  tags                                    = var.tags
}

### AP-SOUTHEAST-1
module "cw_metric_stream_ap-southeast-1" {
  providers = {
    aws = aws.ap-southeast-1
  }
  source                                  = "./modules/cwmetricstream"
  firehose_to_redshift_s3_bucket_name     = var.firehose_to_redshift_s3_bucket_name
  cloudwatch_metric_stream_role_arn       = aws_iam_role.cw_service_role.arn
  kinesis_firehose_role_arn               = aws_iam_role.firehose_role.arn
  kinesis_cw_stream_log_group_name_prefix = var.kinesis_cw_stream_log_group_name_prefix
  redshift_aws_account_id                 = var.redshift_aws_account_id
  redshift_cluster_jdbcurl                = var.redshift_cluster_jdbcurl
  redshift_database_name                  = var.redshift_database_name
  redshift_password                       = data.aws_secretsmanager_secret_version.redshift_secret_get.secret_string
  redshift_s3_bucket_kms_key_id           = var.redshift_s3_bucket_kms_key_id
  redshift_table_name                     = var.redshift_table_name
  redshift_username                       = var.redshift_username
  region                                  = "ap-southeast-1"
  tags                                    = var.tags
}

### SA-EAST-1
module "cw_metric_stream_sa-east-1" {
  providers = {
    aws = aws.sa-east-1
  }
  source                                  = "./modules/cwmetricstream"
  firehose_to_redshift_s3_bucket_name     = var.firehose_to_redshift_s3_bucket_name
  cloudwatch_metric_stream_role_arn       = aws_iam_role.cw_service_role.arn
  kinesis_firehose_role_arn               = aws_iam_role.firehose_role.arn
  kinesis_cw_stream_log_group_name_prefix = var.kinesis_cw_stream_log_group_name_prefix
  redshift_aws_account_id                 = var.redshift_aws_account_id
  redshift_cluster_jdbcurl                = var.redshift_cluster_jdbcurl
  redshift_database_name                  = var.redshift_database_name
  redshift_password                       = data.aws_secretsmanager_secret_version.redshift_secret_get.secret_string
  redshift_s3_bucket_kms_key_id           = var.redshift_s3_bucket_kms_key_id
  redshift_table_name                     = var.redshift_table_name
  redshift_username                       = var.redshift_username
  region                                  = "sa-east-1"
  tags                                    = var.tags
}

### AP-NORTHEAST-1
module "cw_metric_stream_ap-northeast-1" {
  providers = {
    aws = aws.ap-northeast-1
  }
  source                                  = "./modules/cwmetricstream"
  firehose_to_redshift_s3_bucket_name     = var.firehose_to_redshift_s3_bucket_name
  cloudwatch_metric_stream_role_arn       = aws_iam_role.cw_service_role.arn
  kinesis_firehose_role_arn               = aws_iam_role.firehose_role.arn
  kinesis_cw_stream_log_group_name_prefix = var.kinesis_cw_stream_log_group_name_prefix
  redshift_aws_account_id                 = var.redshift_aws_account_id
  redshift_cluster_jdbcurl                = var.redshift_cluster_jdbcurl
  redshift_database_name                  = var.redshift_database_name
  redshift_password                       = data.aws_secretsmanager_secret_version.redshift_secret_get.secret_string
  redshift_s3_bucket_kms_key_id           = var.redshift_s3_bucket_kms_key_id
  redshift_table_name                     = var.redshift_table_name
  redshift_username                       = var.redshift_username
  region                                  = "ap-northeast-1"
  tags                                    = var.tags
}

### AP-NORTHEAST-2
module "cw_metric_stream_ap-northeast-2" {
  providers = {
    aws = aws.ap-northeast-2
  }
  source                                  = "./modules/cwmetricstream"
  firehose_to_redshift_s3_bucket_name     = var.firehose_to_redshift_s3_bucket_name
  cloudwatch_metric_stream_role_arn       = aws_iam_role.cw_service_role.arn
  kinesis_firehose_role_arn               = aws_iam_role.firehose_role.arn
  kinesis_cw_stream_log_group_name_prefix = var.kinesis_cw_stream_log_group_name_prefix
  redshift_aws_account_id                 = var.redshift_aws_account_id
  redshift_cluster_jdbcurl                = var.redshift_cluster_jdbcurl
  redshift_database_name                  = var.redshift_database_name
  redshift_password                       = data.aws_secretsmanager_secret_version.redshift_secret_get.secret_string
  redshift_s3_bucket_kms_key_id           = var.redshift_s3_bucket_kms_key_id
  redshift_table_name                     = var.redshift_table_name
  redshift_username                       = var.redshift_username
  region                                  = "ap-northeast-2"
  tags                                    = var.tags
}

### AP-SOUTHEAST-2
module "cw_metric_stream_ap-southeast-2" {
  providers = {
    aws = aws.ap-southeast-2
  }
  source                                  = "./modules/cwmetricstream"
  firehose_to_redshift_s3_bucket_name     = var.firehose_to_redshift_s3_bucket_name
  cloudwatch_metric_stream_role_arn       = aws_iam_role.cw_service_role.arn
  kinesis_firehose_role_arn               = aws_iam_role.firehose_role.arn
  kinesis_cw_stream_log_group_name_prefix = var.kinesis_cw_stream_log_group_name_prefix
  redshift_aws_account_id                 = var.redshift_aws_account_id
  redshift_cluster_jdbcurl                = var.redshift_cluster_jdbcurl
  redshift_database_name                  = var.redshift_database_name
  redshift_password                       = data.aws_secretsmanager_secret_version.redshift_secret_get.secret_string
  redshift_s3_bucket_kms_key_id           = var.redshift_s3_bucket_kms_key_id
  redshift_table_name                     = var.redshift_table_name
  redshift_username                       = var.redshift_username
  region                                  = "ap-southeast-2"
  tags                                    = var.tags
}

### CA-CENTRAL-1
module "cw_metric_stream_ca-central-1" {
  providers = {
    aws = aws.ca-central-1
  }
  source                                  = "./modules/cwmetricstream"
  firehose_to_redshift_s3_bucket_name     = var.firehose_to_redshift_s3_bucket_name
  cloudwatch_metric_stream_role_arn       = aws_iam_role.cw_service_role.arn
  kinesis_firehose_role_arn               = aws_iam_role.firehose_role.arn
  kinesis_cw_stream_log_group_name_prefix = var.kinesis_cw_stream_log_group_name_prefix
  redshift_aws_account_id                 = var.redshift_aws_account_id
  redshift_cluster_jdbcurl                = var.redshift_cluster_jdbcurl
  redshift_database_name                  = var.redshift_database_name
  redshift_password                       = data.aws_secretsmanager_secret_version.redshift_secret_get.secret_string
  redshift_s3_bucket_kms_key_id           = var.redshift_s3_bucket_kms_key_id
  redshift_table_name                     = var.redshift_table_name
  redshift_username                       = var.redshift_username
  region                                  = "ca-central-1"
  tags                                    = var.tags
}

### EU-NORTH-1
module "cw_metric_stream_eu-north-1" {
  providers = {
    aws = aws.eu-north-1
  }
  source                                  = "./modules/cwmetricstream"
  firehose_to_redshift_s3_bucket_name     = var.firehose_to_redshift_s3_bucket_name
  cloudwatch_metric_stream_role_arn       = aws_iam_role.cw_service_role.arn
  kinesis_firehose_role_arn               = aws_iam_role.firehose_role.arn
  kinesis_cw_stream_log_group_name_prefix = var.kinesis_cw_stream_log_group_name_prefix
  redshift_aws_account_id                 = var.redshift_aws_account_id
  redshift_cluster_jdbcurl                = var.redshift_cluster_jdbcurl
  redshift_database_name                  = var.redshift_database_name
  redshift_password                       = data.aws_secretsmanager_secret_version.redshift_secret_get.secret_string
  redshift_s3_bucket_kms_key_id           = var.redshift_s3_bucket_kms_key_id
  redshift_table_name                     = var.redshift_table_name
  redshift_username                       = var.redshift_username
  region                                  = "eu-north-1"
  tags                                    = var.tags
}

### EU-WEST-1
module "cw_metric_stream_eu-west-1" {
  providers = {
    aws = aws.eu-west-1
  }
  source                                  = "./modules/cwmetricstream"
  firehose_to_redshift_s3_bucket_name     = var.firehose_to_redshift_s3_bucket_name
  cloudwatch_metric_stream_role_arn       = aws_iam_role.cw_service_role.arn
  kinesis_firehose_role_arn               = aws_iam_role.firehose_role.arn
  kinesis_cw_stream_log_group_name_prefix = var.kinesis_cw_stream_log_group_name_prefix
  redshift_aws_account_id                 = var.redshift_aws_account_id
  redshift_cluster_jdbcurl                = var.redshift_cluster_jdbcurl
  redshift_database_name                  = var.redshift_database_name
  redshift_password                       = data.aws_secretsmanager_secret_version.redshift_secret_get.secret_string
  redshift_s3_bucket_kms_key_id           = var.redshift_s3_bucket_kms_key_id
  redshift_table_name                     = var.redshift_table_name
  redshift_username                       = var.redshift_username
  region                                  = "eu-west-1"
  tags                                    = var.tags
}

### EU-WEST-2
module "cw_metric_stream_eu-west-2" {
  providers = {
    aws = aws.eu-west-2
  }
  source                                  = "./modules/cwmetricstream"
  firehose_to_redshift_s3_bucket_name     = var.firehose_to_redshift_s3_bucket_name
  cloudwatch_metric_stream_role_arn       = aws_iam_role.cw_service_role.arn
  kinesis_firehose_role_arn               = aws_iam_role.firehose_role.arn
  kinesis_cw_stream_log_group_name_prefix = var.kinesis_cw_stream_log_group_name_prefix
  redshift_aws_account_id                 = var.redshift_aws_account_id
  redshift_cluster_jdbcurl                = var.redshift_cluster_jdbcurl
  redshift_database_name                  = var.redshift_database_name
  redshift_password                       = data.aws_secretsmanager_secret_version.redshift_secret_get.secret_string
  redshift_s3_bucket_kms_key_id           = var.redshift_s3_bucket_kms_key_id
  redshift_table_name                     = var.redshift_table_name
  redshift_username                       = var.redshift_username
  region                                  = "eu-west-2"
  tags                                    = var.tags
}

### EU-WEST-3
module "cw_metric_stream_eu-west-3" {
  providers = {
    aws = aws.eu-west-3
  }
  source                                  = "./modules/cwmetricstream"
  firehose_to_redshift_s3_bucket_name     = var.firehose_to_redshift_s3_bucket_name
  cloudwatch_metric_stream_role_arn       = aws_iam_role.cw_service_role.arn
  kinesis_firehose_role_arn               = aws_iam_role.firehose_role.arn
  kinesis_cw_stream_log_group_name_prefix = var.kinesis_cw_stream_log_group_name_prefix
  redshift_aws_account_id                 = var.redshift_aws_account_id
  redshift_cluster_jdbcurl                = var.redshift_cluster_jdbcurl
  redshift_database_name                  = var.redshift_database_name
  redshift_password                       = data.aws_secretsmanager_secret_version.redshift_secret_get.secret_string
  redshift_s3_bucket_kms_key_id           = var.redshift_s3_bucket_kms_key_id
  redshift_table_name                     = var.redshift_table_name
  redshift_username                       = var.redshift_username
  region                                  = "eu-west-3"
  tags                                    = var.tags
}

### US-WEST-2
module "cw_metric_stream_us-west-2" {
  providers = {
    aws = aws.us-west-2
  }
  source                                  = "./modules/cwmetricstream"
  firehose_to_redshift_s3_bucket_name     = var.firehose_to_redshift_s3_bucket_name
  cloudwatch_metric_stream_role_arn       = aws_iam_role.cw_service_role.arn
  kinesis_firehose_role_arn               = aws_iam_role.firehose_role.arn
  kinesis_cw_stream_log_group_name_prefix = var.kinesis_cw_stream_log_group_name_prefix
  redshift_aws_account_id                 = var.redshift_aws_account_id
  redshift_cluster_jdbcurl                = var.redshift_cluster_jdbcurl
  redshift_database_name                  = var.redshift_database_name
  redshift_password                       = data.aws_secretsmanager_secret_version.redshift_secret_get.secret_string
  redshift_s3_bucket_kms_key_id           = var.redshift_s3_bucket_kms_key_id
  redshift_table_name                     = var.redshift_table_name
  redshift_username                       = var.redshift_username
  region                                  = "us-west-2"
  tags                                    = var.tags
}