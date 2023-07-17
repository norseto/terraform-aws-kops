Kubeconfig utility.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_kops"></a> [kops](#requirement\_kops) | >= 1.25.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kops"></a> [kops](#provider\_kops) | >= 1.25.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kops_kube_config.kube_config](https://registry.terraform.io/providers/eddycharly/kops/latest/docs/data-sources/kube_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the cluster | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of cluster |
| <a name="output_kubeconfig"></a> [kubeconfig](#output\_kubeconfig) | Cluster connection information |
| <a name="output_kubeconfig_raw"></a> [kubeconfig\_raw](#output\_kubeconfig\_raw) | Kubeconfig file raw content |
