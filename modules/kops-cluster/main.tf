/**
 * Set up a Simple Kubernetes cluster for AWS by kOps on existing VPC
 *
 * [Subnet]
 * You can specify the subnet where the node or control-plane will be located
 * in the following way:
 *
 * 1. control_plane_subnet_ids or node_subnet_ids
 * 2. subnet_ids
 *    - Both node and control-plane should be located in the same subnets
 * 3. control_plane_subnet_filter/control_plane_subnet_type and node_subnet_filter/node_subnet_type
 *    - Subnet its name is matched with subnet_filter and type(public/private) is equal to subnet_type
 */
resource "kops_cluster" "cluster" {
  name               = local.cluster_name
  kubernetes_version = try(local.eksd["kubernetesVersion"], local.kubernetes_version)

  config_store {
    base = local.config_base
  }
  service_account_issuer_discovery {
    enable_aws_oidc_provider = true
    discovery_store          = local.discovery
  }

  api {
    access = local.kubernetes_api_access
    dynamic "dns" {
      for_each = toset(lower(local.api_access.type) == "dns" ? ["a"] : [])
      content {}
    }
    dynamic "load_balancer" {
      for_each = toset(lower(local.api_access.type) != "dns" ? ["a"] : [])
      content {
        class = title(local.api_access.spec.class)
        type  = title(local.api_access.spec.type)
      }
    }
  }

  authorization {
    rbac {}
  }

  cloud_provider {
    aws {
      pod_identity_webhook {
        enabled = true
      }
      load_balancer_controller {
        enabled = try(local.addons.load_balancer_controller.enabled, false)
      }
      ebs_csi_driver {
        enabled = local.ebs_driver_enabled
        managed = local.ebs_driver_managed
      }
      node_termination_handler {
        enabled                           = local.term_handler.enabled
        enable_spot_interruption_draining = local.term_handler.enable_spot_interruption_draining
        enable_scheduled_event_draining   = local.term_handler.enable_scheduled_event_draining
        enable_rebalance_monitoring       = local.term_handler.enable_rebalance_monitoring
        enable_rebalance_draining         = local.term_handler.enable_rebalance_draining
        enable_prometheus_metrics         = local.term_handler.enable_prometheus_metrics
        enable_sqs_termination_draining   = local.term_handler.enable_sqs_termination_draining
        exclude_from_load_balancers       = local.term_handler.exclude_from_load_balancers
        managed_asg_tag                   = local.term_handler.managed_asg_tag
        memory_request                    = local.term_handler.memory_request
        cpu_request                       = local.term_handler.cpu_request
        version                           = local.term_handler.version
      }
    }
  }

  cloud_config {}

  external_cloud_controller_manager {
    image = try(local.eksd["cloud-controller-manager-image"], "")
  }

  iam {
    allow_container_registry                 = true
    legacy                                   = false
    use_service_account_external_permissions = true
    dynamic "service_account_external_permissions" {
      for_each = local.service_account_external_permissions
      content {
        name      = service_account_external_permissions.value.name
        namespace = service_account_external_permissions.value.namespace
        aws {
          policy_ar_ns = service_account_external_permissions.value.policy_arns
        }
      }
    }
  }

  networking {
    network_id   = local.vpc_id
    network_cidr = local.vpc_cidr

    tag_subnets {
      value = local.tag_subnets
    }

    topology {
      dns = title(local.dns_type)
    }

    dynamic "subnet" {
      for_each = local.cluster_subnets
      content {
        id   = subnet.value
        name = local.subnet_data[subnet.value].name
        zone = local.subnet_data[subnet.value].zone
        type = title(local.subnet_data[subnet.value].type)
        cidr = local.subnet_data[subnet.value].cidr
      }
    }

    dynamic "amazon_vpc" {
      for_each = setintersection([local.networking], ["amazon_vpc"])
      content {
        dynamic "env" {
          for_each = local.aws_vpc_env
          content {
            name  = env.key
            value = env.value
          }
        }
      }
    }
    dynamic "cilium" {
      for_each = setintersection([local.networking], ["cilium"])
      content {
        enable_remote_node_identity = true
        preallocate_bpf_maps        = true
      }
    }
    dynamic "calico" {
      for_each = setintersection([local.networking], ["calico"])
      content {}
    }
    dynamic "canal" {
      for_each = setintersection([local.networking], ["canal"])
      content {}
    }
  }

  ssh_access = []

  kubelet {
    max_pods                  = local.default_max_pods
    pod_infra_container_image = try(local.eksd["pause-image"], "")
    anonymous_auth {
      value = false
    }
  }

  kube_api_server {
    image = try(local.eksd["kube-apiserver-image"], "")
    anonymous_auth {
      value = false
    }
  }

  kube_controller_manager {
    image = try(local.eksd["kube-controller-manager-image"], "")
  }
  kube_scheduler {
    image = try(local.eksd["kube-scheduler-image"], "")
  }
  kube_proxy {
    enabled = true
    image   = try(local.eksd["kube-proxy-image"], "")
  }
  kube_dns {
    core_dns_image = try(local.eksd["coredns-image"], "")
  }
  control_plane_kubelet {
    pod_infra_container_image = try(local.eksd["pause-image"], "")
    max_pods                  = local.c_config.max_pods
  }

  authentication {
    aws {
      backend_mode = "CRD"
      cluster_id   = local.cluster_name
      image        = try(local.eksd["aws-iam-authenticator-image"], "")
      dynamic "identity_mappings" {
        for_each = local.cluster_users
        content {
          arn      = identity_mappings.value.arn
          username = identity_mappings.value.username
          groups   = identity_mappings.value.groups
        }
      }
    }
  }

  node_problem_detector {
    enabled = local.prob_detector
  }

  # etcd clusters
  etcd_cluster {
    name           = "main"
    cpu_request    = "200m"
    memory_request = "100Mi"

    dynamic "member" {
      for_each = local.c_groups
      content {
        name              = member.value.etcd_name
        instance_group    = member.value.instance_group
        volume_type       = local.etcd_config.volume_type
        volume_iops       = local.etcd_config.volume_iops
        volume_size       = local.etcd_config.volume_size
        volume_throughput = local.etcd_config.volume_throughput
        encrypted_volume  = true
      }
    }
  }

  etcd_cluster {
    name           = "events"
    cpu_request    = "200m"
    memory_request = "100Mi"

    dynamic "member" {
      for_each = local.c_groups
      content {
        name              = member.value.etcd_name
        instance_group    = member.value.instance_group
        volume_type       = local.etcd_config.volume_type
        volume_iops       = local.etcd_config.volume_iops
        volume_size       = local.etcd_config.volume_size
        volume_throughput = local.etcd_config.volume_throughput
        encrypted_volume  = true
      }
    }
  }

  karpenter {
    enabled = local.karpenter
  }

  metrics_server {
    enabled  = true
    insecure = true
    image    = try(local.eksd["metrics-server-image"], "")
  }
  cert_manager {
    managed = try(local.addons.cert_manager.enabled, true)
    enabled = true
  }
  cluster_autoscaler {
    enabled                       = !local.karpenter && try(local.addons.cluster_autoscaler.enabled, false)
    skip_nodes_with_system_pods   = try(local.addons.cluster_autoscaler.skip_nodes_with_system_pods, false)
    skip_nodes_with_local_storage = try(local.addons.cluster_autoscaler.skip_nodes_with_local_storage, true)
    image                         = try(local.addons.cluster_autoscaler.image, "")
  }

  dynamic "external_policies" {
    for_each = tolist(local.ssm_agents)
    content {
      key   = external_policies.value
      value = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
    }
  }

  lifecycle {
    ignore_changes = [
      secrets,
      authentication[0].aws[0].identity_mappings[0],
      api[0].public_name,
      etcd_cluster[0].manager,
      etcd_cluster[1].manager,
    ]
  }
}
