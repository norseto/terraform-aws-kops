output "public_subnets" {
  description = "List of public subnet_id"
  value       = flatten([for r in local.routes : r.subnets if length(r.gateways) > 0])
}

output "private_subnets" {
  description = "List of private subnet_id"
  value       = flatten([for r in local.routes : r.subnets if length(r.gateways) < 1])
}

output "subnet_data" {
  description = "map of subnet types. key: subnet_id, value: {private, public, type, az_name, az_id, cidr}"
  value       = { for k, v in local.stypes : k => merge(v, { type : v.public ? "Public" : "Private" }) }
}
