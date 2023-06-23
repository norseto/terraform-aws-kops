output "cluster_name" {
  description = "Cluster name"
  value       = local.cluster_name
}

output "KOPS_CLUSTER_NAME" {
  description = "Cluster name for environment"
  value       = local.cluster_name
}

output "revisions" {
  description = "revision map for updater"
  value = merge(
    { cluster : kops_cluster.cluster.revision },
    { for k, n in merge(kops_instance_group.nodes, kops_instance_group.masters) : k => n.revision }
  )
}

output "cmd" {
  description = "Command to get config file"
  value       = "kops export kubeconfig --name '${local.cluster_name}' --state 's3://${local.state_store_id}' --admin"
}

output "ondemand_instance_count" {
  description = "Instance count of least on-demand worker node instance"
  value       = sum([for n in local.nodes : coalesce(n.on_demand_base, can(n.max_price) ? 0 : 1)])
}

output "cluster_secrets" {
  description = "Cluster secret values"
  value       = kops_cluster.cluster.secrets
  sensitive   = true
}
