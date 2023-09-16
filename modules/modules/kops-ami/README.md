Module for finding AMI machine image for instancegroup.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.50.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.50.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ami.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_ec2_instance_type.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_instance_type) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | list of instance type. | `list(string)` | `[]` | no |
| <a name="input_name_filter"></a> [name\_filter](#input\_name\_filter) | AMI name filter | `string` | `""` | no |
| <a name="input_owners"></a> [owners](#input\_owners) | AMI owners | `list(string)` | <pre>[<br>  "099720109477"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_image_full_name"></a> [image\_full\_name](#output\_image\_full\_name) | AMI image full name |
| <a name="output_image_id"></a> [image\_id](#output\_image\_id) | AMI image ID |
| <a name="output_image_name"></a> [image\_name](#output\_image\_name) | AMI image name |
| <a name="output_owner_id"></a> [owner\_id](#output\_owner\_id) | AMI image owner ID |
