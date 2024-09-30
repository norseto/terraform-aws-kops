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
    for_each = length(local.region) > 0 ? [local.region] : []
    content {
      name  = "region"
      value = set.value
    }
  }

  dynamic "set" {
    for_each = local.set_values
    content {
      name  = set.key
      value = set.value
    }
  }
}
