variable "create" {
  description = "If true, remove affinity"
  type = object({
    install        = optional(bool, false)
    kubeconfig_raw = optional(string, "")
  })
  default = {}

  validation {
    condition     = !var.create.install || var.create.kubeconfig_raw
    error_message = "kubeconfig_raw is required when patching autoscaler"
  }
}
