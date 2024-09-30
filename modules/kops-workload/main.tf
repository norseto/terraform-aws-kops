/**
 * Set up common workloads for kOps cluster.
 *
 * This module installes:
 * - cert-manager (Self-Managed)
 * - aws-load-balancer-controller (Self-Managed)
 * - aws-for-fluent-bit
 * - efs-csi-driver
 * - ebs-csi-driver (Self-Managed)
 */

module "cert_manager" {
  source = "./cert_manager"

  create        = !local.managed_cert_manager
  chart_version = local.install.cert_manager.version
  set_values    = local.install.cert_manager.set
}

module "load_balancer_controller" {
  source = "./aws_load_balancer_controller"

  create        = !local.managed_load_balancer_controller && local.install.load_balancer_controller.install
  cluster_name  = local.cluster_name
  region        = local.region
  vpc_id        = local.vpc_id
  chart_version = local.install.load_balancer_controller.version
  set_values    = local.install.load_balancer_controller.set

  depends_on = [module.cert_manager]
}

module "efs_csi_driver" {
  source = "./efs_csi_driver"

  create        = local.install.efs_csi_driver.install
  region        = local.region
  chart_version = local.install.efs_csi_driver.version
  set_values    = local.install.efs_csi_driver.set

  depends_on = [module.cert_manager]
}

module "ebs_csi_driver" {
  source = "./ebs_csi_driver"

  create        = !local.managed_ebs_csi_driver && local.install.ebs_csi_driver.install
  region        = local.region
  chart_version = local.install.ebs_csi_driver.version
  set_values    = local.install.ebs_csi_driver.set

  depends_on = [module.cert_manager]
}

module "fluent_bit" {
  source = "./aws_for_fluent_bit"

  chart_version = local.install.fluent_bit.version
  set_values    = local.install.fluent_bit.set

  cloudwatch     = local.install.fluent_bit.install && local.install.fluent_bit.cloudwatch ? "enabled" : "disabled"
  log_group_name = local.install.fluent_bit.log_group_name
  region         = local.region

  firehose        = local.install.fluent_bit.install && local.install.fluent_bit.firehose ? "enabled" : "disabled"
  firehose_stream = local.install.fluent_bit.firehose_stream

  depends_on = [module.cert_manager]
}
