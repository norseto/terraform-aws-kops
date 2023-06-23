resource "random_pet" "discovery" {
  keepers = {
    state_name = local.state_name
  }
}

locals {
  state_name = var.state_name
  state_suffixes = {
    none : ""
    region : "-${data.aws_region.current.name}"
    account_id : "-${data.aws_caller_identity.current.account_id}"
    full : "-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"
  }
  state_suffix   = local.state_suffixes[var.state_suffix]
  discovery_base = length(var.discovery_name) > 0 ? var.discovery_name : local.state_name
  discovery_name = "${local.discovery_base}-${random_pet.discovery.id}"

  prefix = length(var.prefix) > 0 ? "${var.prefix}-" : ""

  region_name = data.aws_region.current.name
  account_id  = data.aws_caller_identity.current.account_id

  policies = {
    ec2 : "AmazonEC2FullAccess"
    r53 : "AmazonRoute53FullAccess"
    s3 : "AmazonS3FullAccess"
    iam : "IAMFullAccess"
    vpc : "AmazonVPCFullAccess"
    sqs : "AmazonSQSFullAccess"
    evb : "AmazonEventBridgeFullAccess"
  }
}
