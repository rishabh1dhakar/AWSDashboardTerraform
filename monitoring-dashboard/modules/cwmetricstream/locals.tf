locals {
  kinesis_stream_name            = "kns-${var.region}-${local.account_id}-cw-metrics-stream"
  cloudwatch_metrics_stream_name = "kv-${var.region}-${local.account_id}-cw-metrics-stream"
  account_id                     = data.aws_caller_identity.current.account_id
  org_id                         = data.aws_organizations_organization.current.id
}