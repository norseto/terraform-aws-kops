locals {
  vpc_id       = var.vpc_id
  vpc_cidr     = data.aws_vpc.vpc.cidr_block_associations[0].cidr_block
  cluster_name = "${var.prefix}${var.cluster_name}"
  dns_type     = lower(var.dns_type)
  api_access   = var.api_access

  networking_options = var.networking_options
  default_max_pods   = var.default_max_pods

  # Control Plane Config
  c_config = var.control_plane_config

  # Security
  kubernetes_api_access           = var.kubernetes_api_access
  additional_security_group_ids   = var.additional_security_group_ids
  c_additional_security_group_ids = local.c_config.additional_security_group_ids

  # Subnets
  tag_subnets = var.tag_subnets || local.karpenter
  subnet_ids  = var.subnet_ids
  c_filter    = var.control_plane_subnet_filter
  n_filter    = var.node_subnet_filter
  lb_filter   = var.load_balancer_subnet_filter
  c_type      = lower(var.control_plane_subnet_type)
  n_type      = lower(var.node_subnet_type)
  lb_type     = var.api_access.type == "dns" ? "n/a" : lower(var.api_access.spec.type)

  # Subnet should be ordered with its Name and SubnetId
  sub_name_map = {
    for k, v in module.subnet_data.subnet_data :
    "${v.name}-${k}" => { id : k, zone_id : v.az_id, public : v.public }
  }
  # Make uniq name in case multiple subnets exist in the same zone
  az_id_map = {
    for z in distinct([for dz in module.subnet_data.subnet_data : dz.az_id]) :
    z => concat(
      [for n in sort(keys(local.sub_name_map)) : local.sub_name_map[n].id
      if local.sub_name_map[n].zone_id == z && local.sub_name_map[n].public],
      [for n in sort(keys(local.sub_name_map)) : local.sub_name_map[n].id
      if local.sub_name_map[n].zone_id == z && !local.sub_name_map[n].public]
    )
  }
  id_az_name = merge([
    for z, s in local.az_id_map : {
      for i, id in s : id => { name : "${z}-${i}", sk : "${i}-${z}" }
  }]...)

  subnet_data = {
    for k, d in module.subnet_data.subnet_data : k => {
      id : k
      name : local.id_az_name[k].name
      sort : local.id_az_name[k].sk
      subnet_name : d.name
      zone : d.az_name
      zone_id : d.az_id
      cidr : d.cidr
      type : lower(d.type)
      public : d.public
    }
  }

  # Order default typed subnets with Zone and its order
  subnet_order = {
    for k, d in local.subnet_data :
    d.sort => { id : k, public : d.public, sname : d.subnet_name }
  }

  # Filtered subnets
  c_filtered = [
    for i in sort([for k, v in local.subnet_order : k if length(regexall(local.c_filter, v.sname)) > 0]) :
    local.subnet_order[i].id
  ]
  n_filtered = [
    for i in sort([for k, v in local.subnet_order : k if length(regexall(local.n_filter, v.sname)) > 0]) :
    local.subnet_order[i].id
  ]
  lb_filtered = [
    for i in sort([for k, v in local.subnet_order : k if length(regexall(local.lb_filter, v.sname)) > 0]) :
    local.subnet_order[i].id
  ]

  # Shoud be the same topology
  c_filtered_topology = coalesce(local.c_type, try(local.subnet_data[local.c_filtered[0]].type, "public"))
  c_filtered_subnets  = [for i in local.c_filtered : i if local.subnet_data[i].type == local.c_filtered_topology]
  n_filtered_topology = coalesce(local.n_type, try(local.subnet_data[local.n_filtered[0]].type, "public"))
  n_filtered_subnets  = [for i in local.n_filtered : i if local.subnet_data[i].type == local.n_filtered_topology]

  # Subnet IDs for controller and nodes.
  c_subnet_ids = coalescelist(var.control_plane_subnet_ids, local.subnet_ids, local.c_filtered_subnets)
  n_subnet_ids = coalescelist(var.node_subnet_ids, local.subnet_ids, local.n_filtered_subnets)

  # Subnet details for controller and nodes.
  c_subnets = [for s in local.c_subnet_ids : local.subnet_data[s]]
  n_subnets = [for s in local.n_subnet_ids : local.subnet_data[s]]

  # Decide controller subnet and etcd instances.
  alloc       = local.c_config.default_allocation
  c_ondemands = local.c_config.on_demand_base

  c_groups = merge([for i, s in local.c_subnets : {
    for ii in range(0, local.c_config.arrangement[i]) :
    "${s.name}-${ii}" => {
      etcd_name : "etcd-${s.name}-${ii}"
      zone : s.zone
      subnet : s.name
      instance_group : format("%s-%d-%s", s.name, ii,
      try(local.c_ondemands[i], local.alloc.on_demand_base) > 0 ? "od" : "sp")
      subnet_id : s.id
      on_demand_base : try(local.c_ondemands[i], local.alloc.on_demand_base)
      max_price : coalesce(try(local.c_config.max_prices[i], null), local.alloc.max_price)
      instances : coalescelist(try(local.c_config.instances[i], []), local.alloc.instances)
    }
    } if try(local.c_config.arrangement[i], 0) > 0
  ]...)

  # Nodes
  nodes = [
    for i, v in var.nodes :
    merge(v, { name = try(v.name, "node-${i}") })
  ]

  # LoadBalancer
  lb_subnets = setunion(flatten([
    for s in local.c_groups : [
      for d in [for f in local.lb_filtered : local.subnet_data[f]] :
      d.id if d.type == local.lb_type && d.zone_id == local.subnet_data[s.subnet_id].zone_id
    ]
  ]))

  # Cluster Configuration
  cluster_subnets    = setunion([for k, v in local.c_groups : v.subnet_id], local.n_subnet_ids, local.lb_subnets)
  state_store_id     = var.state_store_id
  config_base        = "s3://${local.state_store_id}/${local.cluster_name}"
  kubernetes_version = try(reverse(split("/", local.eksd["kubernetesVersion"]))[0], var.kubernetes_version)

  addons = var.addons == null ? {} : var.addons
  addon_install = {
    for a in keys(local.addons) : a => try(local.addons[a].managed, try(local.addons[a].enabled, true))
  }

  # Common ServiceAccount Policies
  common_policies = {
    load_balancer_controller : {
      name : "aws-load-balancer-controller"
      template : "${path.module}/templates/aws-load-balancer-controller.json.tftpl"
      override : "load_balancer_controller"
    },
    aws_for_fluent_bit : {
      name : "aws-for-fluent-bit"
      template : "${path.module}/templates/aws-for-fluent-bit.json.tftpl"
    },
    efs_csi_controller : {
      name : "efs-csi-controller-sa"
      template : "${path.module}/templates/aws-efs-csi-driver.json.tftpl"
    },
    cluster_autoscaler : {
      name : "cluster-autoscaler"
      template : "${path.module}/templates/cluster-autoscaler.json.tftpl"
      override : "cluster_autoscaler"
    },
    ebs_csi_driver : {
      name : "ebs-csi-controller"
      policy_arns : ["arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"]
      override : "ebs_csi_driver"
    }
  }

  # EBS-CSI-Driver config
  ebs_csi            = local.addons.ebs_csi_driver
  ebs_driver_managed = local.ebs_csi.managed
  ebs_driver_enabled = true

  # IRSA
  discovery_store_id = coalesce(var.discovery_store_id, var.state_store_id)
  discovery_key      = local.state_store_id == local.discovery_store_id ? "${local.cluster_name}/discovery" : local.cluster_name
  discovery          = "s3://${local.discovery_store_id}/${local.discovery_key}"
  common_addon_permissions = [
    for p in local.common_policies : {
      name : "${p.name}-sa"
      namespace : "kube-system"
      policy_arns : p.policy_arns
    } if !try(local.addon_install[p.override], false) && can(p.policy_arns)
  ]

  service_account_external_permissions = {
    for p in concat(var.service_account_external_permissions, module.common_sa_policies.policy_list, local.common_addon_permissions) :
    "${p.namespace}::${p.name}" => {
      name : p.name
      namespace : p.namespace
      policy_arns : p.policy_arns
    } if !try(local.addon_install[p.override], false)
  }

  # SSM Agent
  ssm_agents = concat(
    var.ssm_agent.control_plane ? ["control-plane"] : [],
    var.ssm_agent.node ? ["node"] : [],
  )

  # EKS Distro
  eksd = var.eksd_config

  # Authenticator
  iam_exp       = "arn:aws:(.+)::(\\d+):([^/]+)/([^/]+)(/.+)?"
  acc_pat       = regex(local.iam_exp, data.aws_caller_identity.current.arn)
  acc_typ       = local.acc_pat[2] == "user" ? "user" : "role"
  caller_arn    = "arn:aws:iam::${local.acc_pat[1]}:${local.acc_typ}/${local.acc_pat[3]}"
  admin_user    = { arn : local.caller_arn, username : "kops_admin", groups : ["system:masters"] }
  cluster_users = concat([local.admin_user], [for u in var.additional_users : u if u.arn != local.caller_arn])

  # Etcd
  etcd_config = var.etcd_volume_config

  # Other
  term_handler   = var.node_termination_handler
  prob_detector  = var.node_problem_detector
  karpenter      = var.karpenter
  custom_manager = local.karpenter
  networking     = lower(var.networking)
  image_map = var.aws_vpc_workaround ? {
    amazon_vpc : "ubuntu/images/*/ubuntu-focal-20.04-*"
  } : {}

  image_filter = try(coalesce(var.machine_image.filter, local.image_map[local.networking]), "")
  image_owners = var.machine_image.owners

  # AWS VPC CNI
  prefix_env = {
    ENABLE_PREFIX_DELEGATION : "true"
    WARM_PREFIX_TARGET : "1"
  }
  aws_vpc_opts = local.networking_options.amazon_vpc
  aws_vpc_env  = merge(local.aws_vpc_opts.env, local.aws_vpc_opts.prefix_enabled ? local.prefix_env : {})
}
