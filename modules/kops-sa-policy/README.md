Set up IAM Policy that will be bound to Kubernetes ServiceAccounts.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.50.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_policies"></a> [aws\_policies](#module\_aws\_policies) | terraform-aws-modules/iam/aws//modules/iam-policy | 5.11.1 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of cluster | `string` | n/a | yes |
| <a name="input_policies"></a> [policies](#input\_policies) | policies to create | <pre>map(object({<br/>    # IRSA ServiceAccountName<br/>    name = string<br/>    # IRSA ServiceAccount Namespace<br/>    namespace = optional(string, "kube-system")<br/>    # IAM Policy JSON string<br/>    policy = string<br/>    # If this entry overrides addon ServiceAccount, specify addon name<br/>    override = optional(string, "")<br/>  }))</pre> | `{}` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | The prefix of name of the cluster | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_policy_list"></a> [policy\_list](#output\_policy\_list) | list of policies created. Can be userd as value of<br/>    service\_account\_external\_permissions parameter of kops-cluster |
