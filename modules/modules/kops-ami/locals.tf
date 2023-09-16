locals {
  owners         = coalescelist(var.owners, ["099720109477"])
  name_filter    = var.name_filter
  instance_types = coalescelist(var.instance_types, ["t3a.small"])
  architectures  = distinct(flatten([for t, i in data.aws_ec2_instance_type.this : i.supported_architectures]))
}
