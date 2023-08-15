/**
 * Set up Cert-Manager by Helm
 */
resource "helm_release" "this" {
  count = local.create ? 1 : 0

  name      = "cert-manager"
  namespace = "kube-system"

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = local.chart_version

  set {
    name  = "installCRDs"
    value = true
  }
  set {
    name  = "global.priorityClassName"
    value = "system-cluster-critical"
  }
  # Set fake kOps labels to pods so that pod-identity-webhook will not
  # stop cert-manager. They are interdependent.
  set {
    name  = "podLabels.kops\\.k8s\\.io/managed-by"
    value = "kops"
  }

  set {
    name  = "startupapicheck.podLabels.kops\\.k8s\\.io/managed-by"
    value = "kops"
  }

  set {
    name  = "webhook.podLabels.kops\\.k8s\\.io/managed-by"
    value = "kops"
  }

  set {
    name  = "cainjector.podLabels.kops\\.k8s\\.io/managed-by"
    value = "kops"
  }

  dynamic "set" {
    for_each = local.set_values
    content {
      name  = set.key
      value = set.value
    }
  }
}
