locals {
  cluster_name                     = var.cluster_name
  cluster                          = data.kops_cluster.cluster
  vpc_id                           = local.cluster.network_id
  zone                             = local.cluster.subnet[0].zone
  region                           = data.aws_availability_zone.zone.region
  managed_load_balancer_controller = try(local.cluster.aws_load_balancer_controller[0].enabled, false)
  managed_cert_manager             = try(local.cluster.cert_manager[0].managed, false)

  install = var.installation
}
