data "kops_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_availability_zone" "zone" {
  name = local.zone
}
