data "aws_route_tables" "rts" {
  vpc_id = var.vpc_id
}

data "aws_route_table" "route_tables" {
  for_each       = toset(data.aws_route_tables.rts.ids)
  route_table_id = each.value
}

data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

data "aws_subnet" "subnet" {
  for_each = toset(data.aws_subnets.subnets.ids)
  id       = each.value
}
