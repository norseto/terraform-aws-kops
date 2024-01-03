locals {
  instance_types = coalescelist(var.instance_types, ["t3a.small"])
  architectures  = distinct(flatten([for t, i in data.aws_ec2_instance_type.this : i.supported_architectures]))
  burstables     = distinct(flatten([for t, i in data.aws_ec2_instance_type.this : i.burstable_performance_supported]))

  machine_type = try(data.aws_ec2_instance_types.this.instance_types[0], "t3a.small")
  burstable    = try(local.burstables[0], true)
}
