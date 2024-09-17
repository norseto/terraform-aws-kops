locals {
  cluster_name                     = var.cluster_name
  cluster                          = data.kops_cluster.cluster
  vpc_id                           = local.cluster.networking[0].network_id
  zone                             = local.cluster.networking[0].subnet[0].zone
  region                           = data.aws_availability_zone.zone.region
  managed_load_balancer_controller = try(local.cluster.cloud_provider[0].aws[0].load_balancer_controller[0].enabled, false)
  managed_cert_manager             = try(local.cluster.cert_manager[0].managed, false)

  install = var.installation
}
