variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
}

variable "chart_version" {
  description = "helm chart version"
  type        = string
  default     = null
}

variable "create" {
  description = "If true, deploy workload"
  type        = bool
  default     = false
}

variable "set_values" {
  description = "Additional set values"
  type        = map(string)
  default     = {}
}
