/**
 * Set up EFS-CSI-Driver by Helm
 */
resource "helm_release" "this" {
  count = local.create ? 1 : 0

  name      = "aws-efs-csi-driver"
  namespace = "kube-system"

  repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"
  chart      = "aws-efs-csi-driver"
  version    = local.chart_version

  set {
    name  = "controller.serviceAccount.create"
    value = true
  }
  set {
    name  = "controller.serviceAccount.name"
    value = "efs-csi-controller-sa"
  }
  set {
    name  = "controller.serviceAccount.name"
    value = "efs-csi-controller-sa"
  }

  dynamic "set" {
    for_each = length(local.region) > 0 ? [local.region] : []
    content {
      name  = "image.repository"
      value = "602401143452.dkr.ecr.${set.value}.amazonaws.com/eks/aws-efs-csi-driver"
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

