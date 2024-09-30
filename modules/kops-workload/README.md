Set up common workloads for kOps cluster.

This module installes:
- cert-manager (Self-Managed)
- aws-load-balancer-controller (Self-Managed)
- aws-for-fluent-bit
- efs-csi-driver
- ebs-csi-driver (Self-Managed)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.9.0 |
| <a name="requirement_kops"></a> [kops](#requirement\_kops) | >= 1.30.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_kops"></a> [kops](#provider\_kops) | >= 1.30.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cert_manager"></a> [cert\_manager](#module\_cert\_manager) | ./cert_manager | n/a |
| <a name="module_ebs_csi_driver"></a> [ebs\_csi\_driver](#module\_ebs\_csi\_driver) | ./ebs_csi_driver | n/a |
| <a name="module_efs_csi_driver"></a> [efs\_csi\_driver](#module\_efs\_csi\_driver) | ./efs_csi_driver | n/a |
| <a name="module_fluent_bit"></a> [fluent\_bit](#module\_fluent\_bit) | ./aws_for_fluent_bit | n/a |
| <a name="module_load_balancer_controller"></a> [load\_balancer\_controller](#module\_load\_balancer\_controller) | ./aws_load_balancer_controller | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_availability_zone.zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zone) | data source |
| [kops_cluster.cluster](https://registry.terraform.io/providers/terraform-kops/kops/latest/docs/data-sources/cluster) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of cluster | `string` | n/a | yes |
| <a name="input_installation"></a> [installation](#input\_installation) | Workload configurations to install | <pre>object({<br/>    # Self-Managed Cert-Manager<br/>    # Cert-Manager will be installed when cert-manager add-on is not present.<br/>    cert_manager = optional(object({<br/>      # Chart version<br/>      version = optional(string, "")<br/>      set     = optional(map(string), {})<br/>    }), {})<br/>    # Self-Managed LoadBalancerController<br/>    # LoadBalancerController will not be installed when add-on is present.<br/>    load_balancer_controller = optional(object({<br/>      install = optional(bool, true)<br/>      # Chart version<br/>      version = optional(string, "")<br/>      set     = optional(map(string), {})<br/>    }), {})<br/>    # aws-for-fluentbit will not be installed when both cloudwatch and firehose is false.<br/>    fluent_bit = optional(object({<br/>      install = optional(bool, true)<br/>      # Chart version<br/>      version = optional(string, "")<br/>      # Enable cloudwatch<br/>      cloudwatch     = optional(bool, false)<br/>      log_group_name = optional(string, "")<br/>      # Enable firehose<br/>      firehose        = optional(bool, false)<br/>      firehose_stream = optional(string, "")<br/>      set             = optional(map(string), {})<br/>    }), {})<br/>    efs_csi_driver = optional(object({<br/>      install = optional(bool, true)<br/>      # Chart version<br/>      version = optional(string, "")<br/>      set     = optional(map(string), {})<br/>    }), {})<br/>    ebs_csi_driver = optional(object({<br/>      install = optional(bool, true)<br/>      # Chart version<br/>      version = optional(string, "")<br/>      set     = optional(map(string), {})<br/>    }), {})<br/>  })</pre> | `{}` | no |

## Outputs

No outputs.
