locals {
  cluster_name = "${var.prefix}${var.cluster_name}"
  policies     = var.policies
}
