output "cluster_name" {
  description = "The name of cluster"
  value       = var.cluster_name
}

output "cmd" {
  description = "Command to get config file"
  value       = "kops export kubeconfig --name '${var.cluster_name}' --state 's3://${var.state_store_id}' --admin"
}
