/**
 * Set up IAM Policy that will be bound to Kubernetes ServiceAccounts.
 */
module "aws_policies" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.11.1"

  for_each = local.policies
  name     = "${local.cluster_name}-sa-${each.key}"
  path     = "/"

  policy = each.value.policy
}
