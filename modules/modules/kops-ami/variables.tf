variable "instance_types" {
  description = "list of instance type."
  type        = list(string)
  default     = []
}

variable "owners" {
  description = "AMI owners"
  type        = list(string)
  default     = ["099720109477"]
}

variable "name_filter" {
  description = "AMI name filter"
  type        = string
  default     = ""
}
