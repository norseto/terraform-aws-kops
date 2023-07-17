Set up AWS for FluentBit For AWS by Helm

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
| <a name="input_cloudwatch"></a> [cloudwatch](#input\_cloudwatch) | enable/disable cloudwatch | `string` | `"disabled"` | no |
| <a name="input_firehose"></a> [firehose](#input\_firehose) | enable/disable firehose | `string` | `"disabled"` | no |
| <a name="input_firehose_stream"></a> [firehose\_stream](#input\_firehose\_stream) | firehose delivery stream name | `string` | `""` | no |
| <a name="input_log_group_name"></a> [log\_group\_name](#input\_log\_group\_name) | log group name | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | CloudWatch region | `string` | `""` | no |
| <a name="input_set_values"></a> [set\_values](#input\_set\_values) | Additional set values | `map(string)` | `{}` | no |

## Outputs

No outputs.
