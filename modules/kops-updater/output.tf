output "cluster_name" {
  description = "The name of cluster"
  value       = var.cluster_name
}

output "cmd" {
  description = "Command to get config file"
  value       = "kops export kubeconfig --name '${var.cluster_name}' --state 's3://${var.state_store_id}' --admin"
}

output "kubeconfig" {
  description = "Cluster connection information"
  value       = module.kube_config.kubeconfig
  sensitive   = true
}

output "kubeconfig_raw" {
  description = "Kubeconfig file raw content"
  value       = var.output_kubeconfig_raw ? module.kube_config.kubeconfig_raw : ""
  sensitive   = true
}
