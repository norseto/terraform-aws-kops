Set up a Simple Kubernetes cluster for AWS by kOps on existing VPC

[Subnet]
You can specify the subnet where the node or control-plane will be located
in the following way:

1. control\_plane\_subnet\_ids or node\_subnet\_ids
2. subnet\_ids
   - Both node and control-plane should be located in the same subnets
3. control\_plane\_subnet\_filter/control\_plane\_subnet\_type and node\_subnet\_filter/node\_subnet\_type
   - Subnet its name is matched with subnet\_filter and type(public/private) is equal to subnet\_type

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_kops"></a> [kops](#requirement\_kops) | ~> 1.29.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_kops"></a> [kops](#provider\_kops) | ~> 1.29.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_common_sa_policies"></a> [common\_sa\_policies](#module\_common\_sa\_policies) | ../kops-sa-policy | n/a |
| <a name="module_cp_machine_image"></a> [cp\_machine\_image](#module\_cp\_machine\_image) | ../modules/kops-ami | n/a |
| <a name="module_cp_machine_type"></a> [cp\_machine\_type](#module\_cp\_machine\_type) | ../modules/kops-machine-type | n/a |
| <a name="module_node_machine_image"></a> [node\_machine\_image](#module\_node\_machine\_image) | ../modules/kops-ami | n/a |
| <a name="module_node_machine_type"></a> [node\_machine\_type](#module\_node\_machine\_type) | ../modules/kops-machine-type | n/a |
| <a name="module_subnet_data"></a> [subnet\_data](#module\_subnet\_data) | ../modules/kops-subnet-data | n/a |

## Resources

| Name | Type |
|------|------|
| [kops_cluster.cluster](https://registry.terraform.io/providers/terraform-kops/kops/latest/docs/resources/cluster) | resource |
| [kops_instance_group.control_planes](https://registry.terraform.io/providers/terraform-kops/kops/latest/docs/resources/instance_group) | resource |
| [kops_instance_group.nodes](https://registry.terraform.io/providers/terraform-kops/kops/latest/docs/resources/instance_group) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_security_group_ids"></a> [additional\_security\_group\_ids](#input\_additional\_security\_group\_ids) | Additional security groups for nodes | `list(string)` | `[]` | no |
| <a name="input_additional_users"></a> [additional\_users](#input\_additional\_users) | Additional users or roles | <pre>list(object({<br>    arn      = string<br>    username = string<br>    groups   = optional(list(string), ["system:masters"])<br>  }))</pre> | `[]` | no |
| <a name="input_addons"></a> [addons](#input\_addons) | kOps managed addons to be installed | <pre>object({<br>    # CertManager always need to be installed because this module always set<br>    # `service_account_issuer_discovery`. So, if false, it should be installed by helm.<br>    # This is for testing cert-manager version testing purpose.<br>    cert_manager = optional(object(<br>      {<br>        enabled = optional(bool, true)<br>      }<br>    ), { enabled = true }),<br>    # LoadBalancerController - Managed LoadBalancerController needs tags on subnet,<br>    # so this module does not install by default.<br>    load_balancer_controller = optional(object(<br>      {<br>        # True will install addon with kOps<br>        enabled = optional(bool, false)<br>      }<br>    ), { enabled : false })<br>    # ClusterAutoscaler Configuration<br>    cluster_autoscaler = optional(object(<br>      {<br>        # True will install addon with kOps<br>        enabled = optional(bool, false)<br>        # Image<br>        image = optional(string, "")<br>        # Skip node with system pods<br>        skip_nodes_with_system_pods = optional(bool, true)<br>        # Skip node with local storage<br>        skip_nodes_with_local_storage = optional(bool, false)<br>      }<br>    ), { enabled : false })<br>  })</pre> | <pre>{<br>  "cluster_autoscaler": {<br>    "enabled": false<br>  },<br>  "load_balancer_controller": {<br>    "enabled": false<br>  }<br>}</pre> | no |
| <a name="input_api_access"></a> [api\_access](#input\_api\_access) | Kubernetes API access type(DNS or LoadBalancer) | <pre>object({<br>    # type: dns or load_balancer<br>    type = optional(string, "dns")<br>    # spec: loadbalancer spec<br>    spec = optional(object({<br>      # LoadBalancer type: Public or Internal<br>      type = optional(string, "Public")<br>      # LoadBalancer class: Network or Classic<br>      class = optional(string, "Network")<br>    }), { type : "Public", class : "Network" })<br>  })</pre> | <pre>{<br>  "spec": {},<br>  "type": "dns"<br>}</pre> | no |
| <a name="input_aws_vpc_workaround"></a> [aws\_vpc\_workaround](#input\_aws\_vpc\_workaround) | amazon\_vpc workaround | `bool` | `true` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the cluster | `string` | n/a | yes |
| <a name="input_common_policy_installation"></a> [common\_policy\_installation](#input\_common\_policy\_installation) | Install common AWS policies for Kubernetes | <pre>object({<br>    load_balancer_controller = optional(bool, true)<br>    aws_for_fluent_bit       = optional(bool, true)<br>    efs_csi_controller       = optional(bool, true)<br>    cluster_autoscaler       = optional(bool, true)<br>  })</pre> | `{}` | no |
| <a name="input_control_plane_config"></a> [control\_plane\_config](#input\_control\_plane\_config) | Control plane configurations | <pre>object({<br>    # Control plane allocation configuration.<br>    # One Autoscaling Group is created per control plane, so this setting<br>    # applies to all control planes individually.<br>    default_allocation = optional(object({<br>      instances                = optional(list(string), ["t3a.medium", "t3.medium"])<br>      max_price                = optional(string, "1.0")<br>      cpu_credits              = optional(string, "standard")<br>      on_demand_base           = optional(number, 1)<br>      spot_allocation_strategy = optional(string, "lowest-price")<br>      max_price                = optional(string, "0.99")<br>    }), {})<br>    # the number of control plane instance group in control_plane_subnet<br>    arrangement = optional(list(number), [1])<br>    # additional security group ids for control_planes<br>    additional_security_group_ids = optional(list(string), [])<br>    # Control-Plain on-demand allocation arrangement.<br>    # If empty, will use the same value as the control_plane_arrangement<br>    on_demand_base = optional(list(number), [])<br>    instances      = optional(list(list(string)), [])<br>    root_volume = optional(object({<br>      volume_type       = optional(string)<br>      volume_iops       = optional(number)<br>      volume_throughput = optional(number)<br>      volume_size       = optional(number)<br>    }), {})<br>  })</pre> | `{}` | no |
| <a name="input_control_plane_subnet_filter"></a> [control\_plane\_subnet\_filter](#input\_control\_plane\_subnet\_filter) | subnet name filter of control planes. Will be used both control\_plane\_subnet\_ids<br>    and subnet\_ids are empty | `string` | `".*"` | no |
| <a name="input_control_plane_subnet_ids"></a> [control\_plane\_subnet\_ids](#input\_control\_plane\_subnet\_ids) | control plane subnet IDs. When empty, subnet\_ids will be used. | `list(string)` | `[]` | no |
| <a name="input_control_plane_subnet_type"></a> [control\_plane\_subnet\_type](#input\_control\_plane\_subnet\_type) | subnet type of control planes. Will be used control\_plane\_subnet\_ids<br>    and subnet\_ids are empty | `string` | `""` | no |
| <a name="input_discovery_store_id"></a> [discovery\_store\_id](#input\_discovery\_store\_id) | OIDC discovery S3 bucket ID | `string` | n/a | yes |
| <a name="input_dns_type"></a> [dns\_type](#input\_dns\_type) | Which type of zone sholud be used. public or private | `string` | `"public"` | no |
| <a name="input_ebs_csi_driver"></a> [ebs\_csi\_driver](#input\_ebs\_csi\_driver) | EBS-CSI-Driver configuration | <pre>object(<br>    {<br>      # Use EBS-CSI-Driver<br>      enabled = optional(bool, true)<br>      # Self Managed EBS-CSI-Driver(Only setup IRSA)<br>      self_managed = optional(bool, false)<br>    }<br>  )</pre> | `{}` | no |
| <a name="input_eksd_config"></a> [eksd\_config](#input\_eksd\_config) | EKS-D configuration. To make configuration, go https://distro.eks.amazonaws.com/ , then select version<br>    and download release manifest. Then run tools/eks-d-mkconf.sh. | `map(any)` | `{}` | no |
| <a name="input_etcd_volume_config"></a> [etcd\_volume\_config](#input\_etcd\_volume\_config) | Etcd volume configurations | <pre>object({<br>    volume_type       = optional(string)<br>    volume_iops       = optional(number)<br>    volume_throughput = optional(number)<br>    volume_size       = optional(number)<br>  })</pre> | `{}` | no |
| <a name="input_karpenter"></a> [karpenter](#input\_karpenter) | Enable Karpenter | `bool` | `false` | no |
| <a name="input_kubernetes_api_access"></a> [kubernetes\_api\_access](#input\_kubernetes\_api\_access) | SSH access CIDR | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes version | `string` | `""` | no |
| <a name="input_load_balancer_subnet_filter"></a> [load\_balancer\_subnet\_filter](#input\_load\_balancer\_subnet\_filter) | subnet name filter of load\_balancer. Will be used when api\_access.type is load\_balancer<br>    and both node\_subnet\_ids and subnet\_ids are empty | `string` | `".*"` | no |
| <a name="input_machine_image"></a> [machine\_image](#input\_machine\_image) | AMI image configuration. currently, control-plane and node are both use this filter | <pre>object({<br>    owners = optional(list(string), [])<br>    filter = optional(string, "")<br>  })</pre> | `{}` | no |
| <a name="input_networking"></a> [networking](#input\_networking) | Netwoking driver | `string` | `"amazon_vpc"` | no |
| <a name="input_node_problem_detector"></a> [node\_problem\_detector](#input\_node\_problem\_detector) | Whether enable Node Problem Detector or not | `bool` | `false` | no |
| <a name="input_node_subnet_filter"></a> [node\_subnet\_filter](#input\_node\_subnet\_filter) | subnet name filter of nodes. Will be used both node\_subnet\_ids<br>    and subnet\_ids are empty | `string` | `".*"` | no |
| <a name="input_node_subnet_ids"></a> [node\_subnet\_ids](#input\_node\_subnet\_ids) | node subnet IDs. When empty, subnet\_ids will be used. | `list(string)` | `[]` | no |
| <a name="input_node_subnet_type"></a> [node\_subnet\_type](#input\_node\_subnet\_type) | subnet type of nodes. Will be used node\_subnet\_ids<br>    and subnet\_ids and node\_subnet\_filter are empty | `string` | `""` | no |
| <a name="input_node_termination_handler"></a> [node\_termination\_handler](#input\_node\_termination\_handler) | Node termination handler configuration | <pre>object({<br>    enabled                           = optional(bool, true)<br>    enable_spot_interruption_draining = optional(bool, true)<br>    enable_scheduled_event_draining   = optional(bool, false)<br>    enable_rebalance_monitoring       = optional(bool, false)<br>    enable_rebalance_draining         = optional(bool, false)<br>    enable_prometheus_metrics         = optional(bool, false)<br>    enable_sqs_termination_draining   = optional(bool, true)<br>    exclude_from_load_balancers       = optional(bool, true)<br>    managed_asg_tag                   = optional(string, "")<br>    memory_request                    = optional(string, "64Mi")<br>    cpu_request                       = optional(string, "50m")<br>    version                           = optional(string, "")<br>  })</pre> | <pre>{<br>  "enabled": false<br>}</pre> | no |
| <a name="input_nodes"></a> [nodes](#input\_nodes) | Node instance groups | <pre>list(object({<br>    name                          = optional(string)<br>    manager                       = optional(string, "")<br>    min_size                      = optional(number, 1)<br>    max_size                      = optional(number, 3)<br>    instances                     = optional(list(string), ["t3a.medium", "t3.medium"])<br>    max_price                     = optional(string, "1.0")<br>    cpu_credits                   = optional(string, "standard")<br>    taints                        = optional(list(string), [])<br>    node_labels                   = optional(map(string), {})<br>    on_demand_base                = optional(number, null)<br>    on_demand_above_base          = optional(number, null)<br>    spot_allocation_strategy      = optional(string, "price-capacity-optimized")<br>    additional_security_group_ids = optional(list(string), [])<br>    root_volume = optional(object({<br>      volume_type       = optional(string)<br>      volume_iops       = optional(number)<br>      volume_throughput = optional(number)<br>      volume_size       = optional(number)<br>    }), {})<br>  }))</pre> | `[]` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | The prefix of name of the cluster | `string` | `""` | no |
| <a name="input_service_account_external_permissions"></a> [service\_account\_external\_permissions](#input\_service\_account\_external\_permissions) | External Policy for ServiceAccount | <pre>list(object({<br>    # Name of the ServiceAccount<br>    name = string<br>    # ServiceAccount namespace<br>    namespace = optional(string, "kube-system")<br>    # If this entry overrides the SerivceAccount of kOps managed addon, specify addon name<br>    override = optional(string, "")<br>    # Policy ARNs<br>    policy_arns = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_ssm_agent"></a> [ssm\_agent](#input\_ssm\_agent) | Whether install SSM Agent or not. Because this module does not set<br>  SSH access configuration, If you want to login to nodes, set true. | <pre>object({<br>    control_plane = optional(bool, false)<br>    node          = optional(bool, false)<br>  })</pre> | <pre>{<br>  "control_plane": false,<br>  "node": false<br>}</pre> | no |
| <a name="input_state_store_id"></a> [state\_store\_id](#input\_state\_store\_id) | State store S3 bucket ID | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | default subnet IDs | `list(string)` | `[]` | no |
| <a name="input_tag_subnets"></a> [tag\_subnets](#input\_tag\_subnets) | Whether tag subenets or not. If karpenter is true, will be set to true. | `bool` | `false` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_KOPS_CLUSTER_NAME"></a> [KOPS\_CLUSTER\_NAME](#output\_KOPS\_CLUSTER\_NAME) | Cluster name for environment |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Cluster name |
| <a name="output_cluster_secrets"></a> [cluster\_secrets](#output\_cluster\_secrets) | Cluster secret values |
| <a name="output_cmd"></a> [cmd](#output\_cmd) | Command to get config file |
| <a name="output_ondemand_instance_count"></a> [ondemand\_instance\_count](#output\_ondemand\_instance\_count) | Instance count of least on-demand worker node instance |
| <a name="output_revisions"></a> [revisions](#output\_revisions) | revision map for updater |
