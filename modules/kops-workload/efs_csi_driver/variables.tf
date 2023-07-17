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

variable "region" {
  description = "AWS image region"
  type        = string
  default     = ""
}

variable "set_values" {
  description = "Additional set values"
  type        = map(string)
  default     = {}
}
