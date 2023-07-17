Apply only kOps cluster updater and creates kubeconfig file.
The validate command will not finish successfully in the following cases.
| Description | Reason |
|----|-----|
Managed Cert-Manager is not installed| pod-identity-webhooks needs Cert-Manager
All node is spot instance| ClusterAutoscaler won't start on spot incences.
Only one worker node| Some workloads need to be deployed on 2 nodes

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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_kube_config"></a> [kube\_config](#module\_kube\_config) | ../kops-kubeconfig | n/a |

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
| <a name="input_output_kubeconfig_raw"></a> [output\_kubeconfig\_raw](#input\_output\_kubeconfig\_raw) | True if you want raw kubeconfig output. | `bool` | `false` | no |
| <a name="input_state_store_id"></a> [state\_store\_id](#input\_state\_store\_id) | State store S3 bucket ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of cluster |
| <a name="output_cmd"></a> [cmd](#output\_cmd) | Command to get config file |
| <a name="output_kubeconfig"></a> [kubeconfig](#output\_kubeconfig) | Cluster connection information |
| <a name="output_kubeconfig_raw"></a> [kubeconfig\_raw](#output\_kubeconfig\_raw) | Kubeconfig file raw content |
