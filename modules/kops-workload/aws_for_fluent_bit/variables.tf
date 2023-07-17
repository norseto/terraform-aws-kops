variable "chart_version" {
  description = "helm chart version"
  type        = string
  default     = null
}

variable "cloudwatch" {
  description = "enable/disable cloudwatch"
  type        = string
  default     = "disabled"

  validation {
    condition     = contains(["enabled", "disabled"], var.cloudwatch)
    error_message = "cloudwatch should be enabled or disabled"
  }
}

variable "region" {
  description = "CloudWatch region"
  type        = string
  default     = ""
}

variable "firehose" {
  description = "enable/disable firehose"
  type        = string
  default     = "disabled"

  validation {
    condition     = contains(["enabled", "disabled"], var.firehose)
    error_message = "firehose should be enabled or disabled"
  }
}

variable "log_group_name" {
  description = "log group name"
  type        = string
  default     = ""
}

variable "firehose_stream" {
  description = "firehose delivery stream name"
  type        = string
  default     = ""
}

variable "set_values" {
  description = "Additional set values"
  type        = map(string)
  default     = {}
}
