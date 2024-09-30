Set up State Bucket for kOps.
See : https://kops.sigs.k8s.io/getting_started/aws/

This terraform module create 2 buckets:
- One for State Store
- One for IRSA OIDC Discovery

The bucket for IRSA OIDC Discovery should be able to public accessible,
we use random pet for its name.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.50.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.4.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.50.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.4.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.kops_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.s3_bucket_discovery](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.kops_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_acl.s3_bucket_discovery](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_ownership_controls.kops_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_ownership_controls.s3_bucket_discovery](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_public_access_block.kops_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_public_access_block.s3_bucket_discovery](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.kops_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.s3_bucket_discovery](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.kops_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_versioning.s3_bucket_discovery](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [random_pet.discovery](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_discovery_name"></a> [discovery\_name](#input\_discovery\_name) | Name for OIDC storage. | `string` | `""` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | value | `string` | `""` | no |
| <a name="input_state_name"></a> [state\_name](#input\_state\_name) | Name for state storage. Actually, prefix and account ID<br/>    and region name will be added. | `string` | n/a | yes |
| <a name="input_state_suffix"></a> [state\_suffix](#input\_state\_suffix) | OIDC bucket name suffix type. full, region, account\_id or none. | `string` | `"full"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_KOPS_STATE_STORE"></a> [KOPS\_STATE\_STORE](#output\_KOPS\_STATE\_STORE) | State storage bucket ID for environment |
| <a name="output_s3_bucket_id"></a> [s3\_bucket\_id](#output\_s3\_bucket\_id) | State storage bucket ID |
| <a name="output_s3_discovery_bucket_id"></a> [s3\_discovery\_bucket\_id](#output\_s3\_discovery\_bucket\_id) | State storage bucket ID |
