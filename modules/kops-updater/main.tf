/**
 * Apply only kOps cluster updater and creates kubeconfig file.
 * The validate command will not finish successfully in the following cases.
 * | Description | Reason |
 * |----|-----|
 * Managed Cert-Manager is not installed| pod-identity-webhooks needs Cert-Manager
 * All node is spot instance| ClusterAutoscaler won't start on spot incences.
 * Only one worker node| Some workloads need to be deployed on 2 nodes
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

module "kube_config" {
  source = "../kops-kubeconfig"

  cluster_name = var.cluster_name
  depends_on   = [kops_cluster_updater.updater]
}
