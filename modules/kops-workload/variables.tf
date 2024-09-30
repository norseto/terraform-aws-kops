variable "cluster_name" {
  description = "The name of cluster"
  type        = string
}

variable "installation" {
  description = "Workload configurations to install"
  type = object({
    # Self-Managed Cert-Manager
    # Cert-Manager will be installed when cert-manager add-on is not present.
    cert_manager = optional(object({
      # Chart version
      version = optional(string, "")
      set     = optional(map(string), {})
    }), {})
    # Self-Managed LoadBalancerController
    # LoadBalancerController will not be installed when add-on is present.
    load_balancer_controller = optional(object({
      install = optional(bool, true)
      # Chart version
      version = optional(string, "")
      set     = optional(map(string), {})
    }), {})
    # aws-for-fluentbit will not be installed when both cloudwatch and firehose is false.
    fluent_bit = optional(object({
      install = optional(bool, true)
      # Chart version
      version = optional(string, "")
      # Enable cloudwatch
      cloudwatch     = optional(bool, false)
      log_group_name = optional(string, "")
      # Enable firehose
      firehose        = optional(bool, false)
      firehose_stream = optional(string, "")
      set             = optional(map(string), {})
    }), {})
    efs_csi_driver = optional(object({
      install = optional(bool, true)
      # Chart version
      version = optional(string, "")
      set     = optional(map(string), {})
    }), {})
    ebs_csi_driver = optional(object({
      install = optional(bool, true)
      # Chart version
      version = optional(string, "")
      set     = optional(map(string), {})
    }), {})
  })
  default = {}
}
