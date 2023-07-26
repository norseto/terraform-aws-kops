variable "cluster_name" {
  description = "The name of cluster"
  type        = string
}

variable "prefix" {
  description = "The prefix of name of the cluster"
  type        = string
  default     = ""
}

variable "policies" {
  description = "policies to create"
  # Key: will be used as a part on policy name
  type = map(object({
    # IRSA ServiceAccountName
    name = string
    # IRSA ServiceAccount Namespace
    namespace = optional(string, "kube-system")
    # IAM Policy JSON string
    policy = string
    # If this entry overrides addon ServiceAccount, specify addon name
    override = optional(string, "")
  }))
  default = {}
}
