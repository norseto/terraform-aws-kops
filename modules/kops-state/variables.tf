variable "prefix" {
  description = "value"
  type        = string
  default     = ""
}

variable "state_name" {
  description = <<EOD
    Name for state storage. Actually, prefix and account ID
    and region name will be added.
  EOD
  type        = string
}

variable "discovery_name" {
  description = "Name for OIDC storage."
  type        = string
  default     = ""
}

variable "state_suffix" {
  description = "OIDC bucket name suffix type. full, region, account_id or none."
  type        = string
  default     = "full"
  validation {
    condition     = contains(["full", "region", "account_id"], var.state_suffix)
    error_message = "state_suffix should be the one of 'none', 'full', 'region' or 'account_id'"
  }
}
