/**
 * Set up AWS LoadBalancer Controller by Helm
 */
resource "helm_release" "this" {
  count = local.create ? 1 : 0

  name      = "aws-load-balancer-controller"
  namespace = "kube-system"

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = local.chart_version

  set {
    name  = "clusterName"
    value = local.cluster_name
  }
  set {
    name  = "vpcId"
    value = local.vpc_id
  }

  dynamic "set" {
    for_each = local.set_values
    content {
      name  = set.key
      value = set.value
    }
  }

  # depends_on = [
  #   helm_release.crd
  # ]
}

# resource "helm_release" "crd" {
#   count = local.create ? 1 : 0

#   name      = "aws-load-balancer-controller-crds"
#   namespace = "kube-system"

#   repository = "https://snowplow-devops.github.io/helm-charts"
#   chart      = "aws-load-balancer-controller-crds"
#   # version    = local.chart_version
# }
