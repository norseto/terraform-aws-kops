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
    spot_allocation_strategy = try(each.value.spot_allocation_strategy, "lowest-price")

    on_demand_base {
      value = coalesce(each.value.on_demand_base, can(each.value.max_price) ? 0 : 1)
    }
    on_demand_above_base {
      value = coalesce(each.value.on_demand_above_base, can(each.value.max_price) ? 0 : 100)
    }
  }
  max_price = each.value.max_price

  cpu_credits  = each.value.cpu_credits
  machine_type = "t3a.small"

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
        sudo snap start amazon-ssm-agent}
      _EOM
    }
  }

  root_volume_type       = each.value.root_volume.volume_type
  root_volume_iops       = each.value.root_volume.volume_iops
  root_volume_throughput = each.value.root_volume.volume_throughput
  root_volume_size       = each.value.root_volume.volume_size

  lifecycle {
    ignore_changes = [labels]
  }
  depends_on = [kops_cluster.cluster]
}
