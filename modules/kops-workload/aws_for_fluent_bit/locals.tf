locals {
  chart_version = var.chart_version
  region        = var.region

  log_group_name  = var.log_group_name
  firehose_stream = var.firehose_stream

  cloudwatch_enabled = var.cloudwatch == "enabled"
  firehose_enabled   = length(local.firehose_stream) > 0 && var.firehose == "enabled"

  set_values = var.set_values
}
