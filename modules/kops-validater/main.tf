/**
 * kOps cluster validater.
 */
resource "kops_cluster_updater" "validate" {
  cluster_name = var.cluster_name

  apply {
  }
  validate {
    timeout = "10m"
  }
  rolling_update {
  }

  keepers = var.keepers
}
