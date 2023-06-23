/**
 * Apply only kOps cluster updater and creates kubeconfig file.
 * Self manager cert manager prevents pod-identity-webhooks start,
 * So, validate will not ends successfully.
 */
resource "kops_cluster_updater" "updater" {
  cluster_name = var.cluster_name

  apply {
  }
  validate {
    skip = true
  }
  rolling_update {
    skip = true
  }

  keepers = var.keepers
}

resource "null_resource" "kubeconfig" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "kops export kubeconfig --name '${var.cluster_name}' --state 's3://${var.state_store_id}' --admin=26280h"
  }
  depends_on = [
    kops_cluster_updater.updater
  ]
}
