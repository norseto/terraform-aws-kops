output "cluster_name" {
  description = "The name of cluster"
  value       = var.cluster_name
}

output "kubeconfig" {
  description = "Cluster connection information"
  value = {
    host                   = data.kops_kube_config.kube_config.server
    username               = data.kops_kube_config.kube_config.kube_user
    password               = data.kops_kube_config.kube_config.kube_password
    client_certificate     = data.kops_kube_config.kube_config.client_cert
    client_key             = data.kops_kube_config.kube_config.client_key
    cluster_ca_certificate = data.kops_kube_config.kube_config.ca_certs
  }
  sensitive = true
}

output "kubeconfig_raw" {
  description = "Kubeconfig file raw content"
  value       = <<_EOF
apiVersion: v1
kind: Config
preferences: {}
clusters:
- cluster:
    certificate-authority-data: ${base64encode(data.kops_kube_config.kube_config.ca_certs)}
    server: ${data.kops_kube_config.kube_config.server}
  name: ${var.cluster_name}
contexts:
- context:
    cluster: ${var.cluster_name}
    user: ${coalesce(data.kops_kube_config.kube_config.kube_user, var.cluster_name)}
  name: ${var.cluster_name}
current-context: ${var.cluster_name}
users:
- name: ${var.cluster_name}
  user:
    client-certificate-data: ${base64encode(data.kops_kube_config.kube_config.client_cert)}
    client-key-data: ${base64encode(data.kops_kube_config.kube_config.client_key)}
  _EOF
  sensitive   = true
}
