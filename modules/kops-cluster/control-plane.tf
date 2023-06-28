resource "kops_instance_group" "masters" {
  for_each = local.c_groups

  cluster_name = kops_cluster.cluster.name
  name         = each.value.instance_group
  role         = "Master"
  labels = {
    "kops.k8s.io/cluster" : kops_cluster.cluster.name
  }
  node_labels = {
    "kops.k8s.io/instancegroup" : each.value.instance_group
  }
  min_size = 1
  max_size = 1
  mixed_instances_policy {
    instances                = each.value.instances
    spot_allocation_strategy = local.alloc.spot_allocation_strategy
    on_demand_base {
      value = each.value.on_demand_base
    }
    on_demand_above_base {
      value = 0
    }
  }
  max_price    = "0.99"
  machine_type = "t3a.small"
  cpu_credits  = local.alloc.cpu_credits

  additional_security_groups = local.c_additional_security_group_ids

  dynamic "additional_user_data" {
    for_each = [for g in local.ssm_agents : g if g == "master"]
    content {
      name    = "ssm-install.sh"
      type    = "text/x-shellscript"
      content = <<_EOM
        #!/bin/sh
        sudo snap install amazon-ssm-agent --classic
        sudo snap start amazon-ssm-agent}
      _EOM
    }
  }

  root_volume_type       = local.c_config.root_volume.volume_type
  root_volume_iops       = local.c_config.root_volume.volume_iops
  root_volume_throughput = local.c_config.root_volume.volume_throughput
  root_volume_size       = local.c_config.root_volume.volume_size

  lifecycle {
    ignore_changes = [labels]
  }

  subnets    = [each.value.subnet]
  depends_on = [kops_cluster.cluster]
}
