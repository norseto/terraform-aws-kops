locals {
  routes = [for r in [for k, v in data.aws_route_table.route_tables : {
    subnets : compact([for a in v.associations : a.subnet_id]),
    gateways : compact([for r in v.routes : r.gateway_id if r.cidr_block == "0.0.0.0/0"])
  }] : r if length(r.subnets) + length(r.gateways) > 0]

  subnet = data.aws_subnet.subnet

  stypes = merge([for r in local.routes : merge({
    for s in r.subnets : s => {
      name : try(local.subnet[s].tags["Name"], "")
      private : length(r.gateways) < 1
      public : length(r.gateways) > 0
      cidr : local.subnet[s].cidr_block
      az_name : local.subnet[s].availability_zone
      az_id : local.subnet[s].availability_zone_id
    }
  })]...)
}
