variable "keepers" {
  description = "Keepers"
  type        = map(number)
  default     = {}
}

variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
}

variable "state_store_id" {
  description = "State store S3 bucket ID"
  type        = string
}

variable "output_kubeconfig_raw" {
  description = "True if you want raw kubeconfig output."
  type        = bool
  default     = false
}
