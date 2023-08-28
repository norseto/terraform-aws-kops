data "aws_ec2_instance_type" "this" {
  for_each = toset(local.instance_types)

  instance_type = each.key
}

data "aws_ec2_instance_types" "this" {
  filter {
    name   = "processor-info.supported-architecture"
    values = local.architectures
  }

  filter {
    name   = "burstable-performance-supported"
    values = ["true"]
  }

  filter {
    name   = "vcpu-info.default-vcpus"
    values = ["2"]
  }

  filter {
    name   = "memory-info.size-in-mib"
    values = ["4096"]
  }
}
