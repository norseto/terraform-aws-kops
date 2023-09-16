data "aws_ec2_instance_type" "this" {
  for_each = toset(local.instance_types)

  instance_type = each.key
}

data "aws_ami" "this" {
  count = length(local.name_filter) > 0 ? 1 : 0

  most_recent = true
  owners      = local.owners

  filter {
    name   = "name"
    values = [local.name_filter]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture"
    values = local.architectures
  }
}
