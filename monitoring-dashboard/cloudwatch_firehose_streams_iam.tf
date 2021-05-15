/*------------------------------
This file creates iam roles and policies for the CLoudWatch metric streams and Kinesis Firehose Streams.
These policies allow access to S3 for storing incoming data from CLoudWatch and collecting data from Firehose,
as well as policies allowing connection to the Redshift cluster from Firehose side.
*/

################################################################### Cloudwatch stream role

resource "aws_iam_role" "cw_service_role" {
  name               = "${local.cloudwatch_metrics_stream_iam}-role"
  assume_role_policy = templatefile("./policies/cloudwatch_assume_role.json", {})
  tags = merge(
    {
      Name = "${local.cloudwatch_metrics_stream_iam}-role"
    },
    var.tags
  )
}

resource "aws_iam_policy" "cw_streams_policy" {
  name = "${local.cloudwatch_metrics_stream_iam}-policy"
  policy = templatefile("./policies/metric_streams_firehose.json", {
    aws_region         = var.region
    current_account_id = data.aws_caller_identity.current.account_id
  })
  tags = merge(
    {
      Name = "${local.cloudwatch_metrics_stream_iam}-policy"
    },
    var.tags
  )
}

resource "aws_iam_role_policy_attachment" "cw_streams_attach" {
  policy_arn = aws_iam_policy.cw_streams_policy.arn
  role       = aws_iam_role.cw_service_role.name
}

####################################################################### Kinesis Firehose role
resource "aws_iam_role" "firehose_role" {
  name               = "${local.kinesis_firehose_iam}-role"
  assume_role_policy = templatefile("./policies/firehose_assume_role.json", {})
  tags = merge(
    {
      Name = "${local.kinesis_firehose_iam}-role"
    },
    var.tags
  )
}

resource "aws_iam_policy" "redshift_access_policy" {
  name = "${local.kinesis_firehose_iam}-redshift-access-policy"
  policy = templatefile("./policies/firehose_redshift_policy.json", {
    redshift_region      = var.region
    kms_via_service_list = jsonencode(formatlist("s3.%s.amazonaws.com", var.additional_regions))
    redshift_account_id  = var.redshift_aws_account_id
    redshift_kms_key_id  = var.redshift_s3_bucket_kms_key_id
    bucket_name          = var.firehose_to_redshift_s3_bucket_name
    current_account_id   = data.aws_caller_identity.current.account_id
    log_group_name       = var.kinesis_cw_stream_log_group_name_prefix #aws_cloudwatch_log_group.cw_stream_log_group.name
  })
  tags = merge(
    {
      Name = "${local.kinesis_firehose_iam}-redshift-access-policy"
    },
    var.tags
  )
}

resource "aws_iam_policy" "s3_access_policy" {
  name = "${local.kinesis_firehose_iam}-s3-access-policy"
  policy = templatefile("./policies/firehose_s3_access_policy.json", {
    aws_region         = var.region
    current_account_id = data.aws_caller_identity.current.account_id
    bucket_name        = var.firehose_to_redshift_s3_bucket_name
  })
  tags = merge(
    {
      Name = "${local.kinesis_firehose_iam}-s3-access-policy"
    },
    var.tags
  )
}

resource "aws_iam_role_policy_attachment" "redshift_policy_att" {
  role       = aws_iam_role.firehose_role.name
  policy_arn = aws_iam_policy.redshift_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "s3_policy_att" {
  policy_arn = aws_iam_policy.s3_access_policy.arn
  role       = aws_iam_role.firehose_role.name
}


