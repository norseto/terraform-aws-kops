Apply only kOps cluster updater and creates kubeconfig file.
Self manager cert manager prevents pod-identity-webhooks start,
So, validate will not ends successfully.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_kops"></a> [kops](#requirement\_kops) | >= 1.25.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kops"></a> [kops](#provider\_kops) | >= 1.25.3 |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kops_cluster_updater.updater](https://registry.terraform.io/providers/eddycharly/kops/latest/docs/resources/cluster_updater) | resource |
| [null_resource.kubeconfig](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the cluster | `string` | n/a | yes |
| <a name="input_keepers"></a> [keepers](#input\_keepers) | Keepers | `map(number)` | `{}` | no |
| <a name="input_state_store_id"></a> [state\_store\_id](#input\_state\_store\_id) | State store S3 bucket ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of cluster |
| <a name="output_cmd"></a> [cmd](#output\_cmd) | Command to get config file |
