Set up EBS-CSI-Driver by Helm

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.9.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.9.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.this](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | helm chart version | `string` | `null` | no |
| <a name="input_create"></a> [create](#input\_create) | If true, deploy workload | `bool` | `false` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS image region | `string` | `""` | no |
| <a name="input_set_values"></a> [set\_values](#input\_set\_values) | Additional set values | `map(string)` | `{}` | no |

## Outputs

No outputs.
