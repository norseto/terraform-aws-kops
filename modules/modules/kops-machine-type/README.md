Module for finding machine\_type for instancegroup.
This moudle find for burstable and same arch type of instance type.

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
| [aws_ec2_instance_type.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_instance_type) | data source |
| [aws_ec2_instance_types.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_instance_types) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | list of instance type. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_machine_type"></a> [machine\_type](#output\_machine\_type) | machine type for template |
