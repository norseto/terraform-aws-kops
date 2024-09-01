module "node_machine_type" {
  source = "../modules/kops-machine-type"

  for_each       = { for n in local.nodes : n.name => n }
  instance_types = each.value.instances
}

module "node_machine_image" {
  source = "../modules/kops-ami"

  for_each       = { for n in local.nodes : n.name => n }
  name_filter    = local.image_filter
  owners         = local.image_owners
  instance_types = each.value.instances
}

resource "kops_instance_group" "nodes" {
  for_each = { for n in local.nodes : n.name => n }

  cluster_name = kops_cluster.cluster.name
  name         = each.key
  labels = {
    "kops.k8s.io/cluster" : kops_cluster.cluster.name
  }
  role     = "Node"
  min_size = each.value.min_size
  max_size = each.value.max_size
  mixed_instances_policy {
    instances                = each.value.instances
    spot_allocation_strategy = try(each.value.spot_allocation_strategy, "price-capacity-optimized")

    on_demand_base {
      value = coalesce(each.value.on_demand_base, can(each.value.max_price) ? 0 : 1)
    }
    on_demand_above_base {
      value = coalesce(each.value.on_demand_above_base, can(each.value.max_price) ? 0 : 100)
    }
  }
  max_price = each.value.max_price

  manager      = local.custom_manager ? title(each.value.manager) : ""
  cpu_credits  = module.node_machine_type[each.key].burstable ? each.value.cpu_credits : null
  machine_type = module.node_machine_type[each.key].machine_type
  image        = module.node_machine_image[each.key].image_full_name

  subnets = [for s in local.n_subnets : s.name]
  additional_security_groups = concat(
  local.additional_security_group_ids, each.value.additional_security_group_ids)

  taints = try(each.value.taints, [])
  node_labels = merge(try(each.value.node_labels, {}),
  { "kops.k8s.io/instancegroup" : each.key })

  dynamic "additional_user_data" {
    for_each = tolist([for g in local.ssm_agents : g if g == "node"])
    content {
      name    = "ssm-install.sh"
      type    = "text/x-shellscript"
      content = <<_EOM
        #!/bin/sh
        sudo snap install amazon-ssm-agent --classic
        sudo snap start amazon-ssm-agent
      _EOM
    }
  }

  root_volume {
    type       = each.value.root_volume.volume_type
    iops       = each.value.root_volume.volume_iops
    throughput = each.value.root_volume.volume_throughput
    size       = each.value.root_volume.volume_size
  }

  lifecycle {
    ignore_changes = [labels]
  }
  depends_on = [kops_cluster.cluster]
}
