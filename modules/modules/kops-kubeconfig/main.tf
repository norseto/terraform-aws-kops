/**
 * Kubeconfig utility.
 */
data "kops_kube_config" "kube_config" {
  cluster_name = var.cluster_name
}
