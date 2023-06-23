variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "prefix" {
  description = "The prefix of name of the cluster"
  type        = string
  default     = ""
}

variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
}

variable "dns_type" {
  description = "Which type of zone sholud be used. public or private"
  type        = string
  default     = "public"
  validation {
    condition     = contains(["public", "private"], lower(var.dns_type))
    error_message = "dns_type should be 'public' or 'private'"
  }
}

variable "api_access" {
  description = "Kubernetes API access type(DNS or LoadBalancer)"
  type = object({
    # type: dns or loadbalancer
    type = optional(string, "dns")
    # spec: loadbalancer spec
    spec = optional(object({
      # LoadBalancer type: Public or Internal
      type = optional(string, "Public")
      # LoadBalancer class: Network or Classic
      class = optional(string, "Network")
    }), { type : "Public", class : "Network" })
  })
  default = {
    type : "dns"
    spec : {}
  }

  validation {
    condition     = contains(["dns", "load_balancer"], lower(var.api_access.type))
    error_message = "api_access.type sholud be dns or loadbalancer"
  }
  validation {
    condition     = lower(var.api_access.type) == "dns" || contains(["public", "internal"], lower(var.api_access.spec.type))
    error_message = "api_access.spec.type should be public or internal"
  }
  validation {
    condition     = lower(var.api_access.type) == "dns" || contains(["network", "classic"], lower(var.api_access.spec.class))
    error_message = "api_access.spec.class should be network or classic"
  }
}

variable "subnet_ids" {
  description = "default subnet IDs"
  type        = list(string)
  default     = []
}

variable "node_subnet_ids" {
  description = "node subnet IDs. When empty, subnet_ids will be used."
  type        = list(string)
  default     = []
}

variable "control_plane_subnet_ids" {
  description = "control plane subnet IDs. When empty, subnet_ids will be used."
  type        = list(string)
  default     = []
}

variable "node_subnet_type" {
  description = <<_EOM
    subnet type of nodes. Will be used node_subnet_ids
    and subnet_ids and node_subnet_filter are empty
  _EOM
  type        = string
  default     = ""
  validation {
    condition     = contains(["", "public", "private"], lower(var.node_subnet_type))
    error_message = "node_subnet_type should be one of 'private', 'public' or empty"
  }
}

variable "control_plane_subnet_type" {
  description = <<_EOM
    subnet type of control planes. Will be used control_plane_subnet_ids
    and subnet_ids are empty
  _EOM
  type        = string
  default     = ""
  validation {
    condition     = contains(["", "public", "private"], lower(var.control_plane_subnet_type))
    error_message = "control_plane_subnet_type should be one of 'private', 'public' or empty"
  }
}

variable "control_plane_subnet_filter" {
  description = <<_EOM
    subnet name filter of control planes. Will be used both control_plane_subnet_ids
    and subnet_ids are empty
  _EOM
  type        = string
  default     = ".*"
}

variable "node_subnet_filter" {
  description = <<_EOM
    subnet name filter of nodes. Will be used both node_subnet_ids
    and subnet_ids are empty
  _EOM
  type        = string
  default     = ".*"
}

variable "load_balancer_subnet_filter" {
  description = <<_EOM
    subnet name filter of load_balancer. Will be used when api_access.type is load_balancer
    and both node_subnet_ids and subnet_ids are empty
  _EOM
  type        = string
  default     = ".*"
}

variable "control_plane_config" {
  type = object({
    # Control plane allocation configuration.
    # One Autoscaling Group is created per control plane, so this setting
    # applies to all control planes individually.
    default_allocation = optional(object({
      instances                = optional(list(string), ["t3a.medium", "t3.medium"])
      max_price                = optional(string, "1.0")
      cpu_credits              = optional(string, "standard")
      on_demand_base           = optional(number, 1)
      spot_allocation_strategy = optional(string, "lowest-price")
    }), {})
    # the number of control plane instance group in control_plane_subnet
    arrangement = optional(list(number), [1])
    # additional security group ids for control_planes
    additional_security_group_ids = optional(list(string), [])
    # Control-Plain on-demand allocation arrangement.
    # If empty, will use the same value as the control_plane_arrangement
    on_demand_base = optional(list(number), [])
    instances      = optional(list(list(string)), [])
  })
  default = {}
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = ""
}

variable "state_store_id" {
  description = "State store S3 bucket ID"
  type        = string
}

variable "discovery_store_id" {
  description = "OIDC discovery S3 bucket ID"
  type        = string
}

variable "ssh_access" {
  description = "SSH access CIDR"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "kubernetes_api_access" {
  description = "SSH access CIDR"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "additional_security_group_ids" {
  description = "Additional security groups for nodes"
  type        = list(string)
  default     = []
}

variable "service_account_external_permissions" {
  description = "External Policy for ServiceAccount"
  type = list(object({
    name        = string
    namespace   = optional(string, "kube-system")
    override    = optional(string, "")
    policy_arns = list(string)
  }))
  default = []
}

variable "addons" {
  description = "Addons to be installed"
  type = object({
    # CertManager configuration - It cannot be disabled. So, enabled means managed.
    cert_manager = optional(object(
      {
        enabled = optional(bool, true)
      }
    ), { enabled = true }),
    # LoadBalancerController configuration
    load_balancer_controller = optional(object(
      {
        # True will install addon with kOps
        enabled = optional(bool, false)
      }
    ), { enabled : false })
    # ClusterAutoscale Configuration
    cluster_autoscaler = optional(object(
      {
        # True will install addon with kOps
        enabled = optional(bool, false)
        # Image
        image = optional(string)
        # Skip node with system pods
        skip_nodes_with_system_pods = optional(bool, true)
        # Skip node with local storage
        skip_nodes_with_local_storage = optional(bool, false)
      }
    ), { enabled : false })
  })
  default = {
    load_balancer_controller : { enabled : false }
    cluster_autoscaler : { enabled : false }
  }
}

variable "tag_subnets" {
  description = "tag subenets"
  type        = bool
  default     = false
}

variable "nodes" {
  description = "Node instance groups"
  default     = []
  type = list(object({
    name                          = optional(string)
    min_size                      = optional(number, 1)
    max_size                      = optional(number, 3)
    instances                     = optional(list(string), ["t3a.medium", "t3.medium"])
    max_price                     = optional(string, "1.0")
    cpu_credits                   = optional(string, "standard")
    taints                        = optional(list(string), [])
    node_labels                   = optional(map(string), {})
    on_demand_base                = optional(number, null)
    on_demand_above_base          = optional(number, null)
    additional_security_group_ids = optional(list(string), [])
  }))
}

variable "ssm_agent" {
  description = "Install SSM Agent"
  type = object({
    control_plane = optional(bool, false)
    node          = optional(bool, false)
  })
  default = {
    control_plane : false
    node : false
  }
}

variable "eksd_config" {
  description = "EKS-D configuration"
  type        = map(any)
  default     = {}
}

variable "additional_users" {
  description = "Additional users"
  type = list(object({
    arn      = string
    username = string
    groups   = optional(list(string), ["system:masters"])
  }))
  default = []
}

variable "node_termination_handler" {
  description = "Node termination handler configuration"
  type = object({
    enabled                           = optional(bool, true)
    enable_spot_interruption_draining = optional(bool, true)
    enable_scheduled_event_draining   = optional(bool, false)
    enable_rebalance_monitoring       = optional(bool, false)
    enable_rebalance_draining         = optional(bool, false)
    enable_prometheus_metrics         = optional(bool, false)
    enable_sqs_termination_draining   = optional(bool, true)
    exclude_from_load_balancers       = optional(bool, true)
    managed_asg_tag                   = optional(string, "")
    memory_request                    = optional(string, "64Mi")
    cpu_request                       = optional(string, "50m")
    version                           = optional(string, "")
  })
  default = { enabled : false }
}

variable "node_problem_detector" {
  description = "Whether enable Node Problem Detector or not"
  type        = bool
  default     = false
}