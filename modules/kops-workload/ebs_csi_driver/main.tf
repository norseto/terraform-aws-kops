/**
 * Set up EBS-CSI-Driver by Helm
 */
resource "helm_release" "this" {
  count = local.create ? 1 : 0

  name = "aws-ebs-csi-driver"

  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  chart      = "aws-ebs-csi-driver"
  namespace  = "kube-system"
  version    = var.chart_version

  set {
    name  = "controller.serviceAccount.create"
    value = true
  }
  set {
    name  = "controller.serviceAccount.name"
    value = "ebs-csi-controller-sa"
  }

  dynamic "set" {
    for_each = length(local.region) > 0 ? [local.region] : []
    content {
      name  = "image.repository"
      value = "602401143452.dkr.ecr.${set.value}.amazonaws.com/eks/aws-ebs-csi-driver"
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

