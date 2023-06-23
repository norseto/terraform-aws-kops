data "aws_vpc" "vpc" {
  id = local.vpc_id
}

data "aws_caller_identity" "current" {}

module "subnet_data" {
  source = "../subnet-data"

  vpc_id = local.vpc_id
}
