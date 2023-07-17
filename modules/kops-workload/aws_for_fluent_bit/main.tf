/**
 * Set up AWS for FluentBit For AWS by Helm
 */
resource "helm_release" "this" {
  count = local.cloudwatch_enabled || local.firehose_enabled ? 1 : 0

  name      = "aws-for-fluent-bit"
  namespace = "kube-system"

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-for-fluent-bit"
  version    = local.chart_version

  set {
    name  = "cloudWatch.region"
    value = local.region
  }
  set {
    name  = "cloudWatch.logGroupName"
    value = local.log_group_name
  }
  set {
    name  = "cloudWatch.logStreamPrefix"
    value = "logs-"
  }
  set {
    name  = "firehose.region"
    value = local.region
  }
  set {
    name  = "firehose.deliveryStream"
    value = local.firehose_stream
  }

  set {
    name  = "cloudWatch.enabled"
    value = local.cloudwatch_enabled
  }
  set {
    name  = "firehose.enabled"
    value = local.firehose_enabled
  }
  set {
    name  = "kinesis.enabled"
    value = false
  }
  set {
    name  = "elasticsearch.enabled"
    value = false
  }
  set {
    name  = "tolerations[0].operator"
    value = "Exists"
  }

  dynamic "set" {
    for_each = local.set_values
    content {
      name  = set.key
      value = set.value
    }
  }
}
