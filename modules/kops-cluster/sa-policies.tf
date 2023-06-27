# AWS IAM Policies for Common ServiceAccounts incl. self managed addons. 
module "common_sa_policies" {
  source = "../kops-sa-policy"

  cluster_name = local.cluster_name
  policies = {
    for k, p in local.common_policies : replace(k, "_", "-") => merge(p,
    { policy : templatefile(p.template, { cluster_name : local.cluster_name }) })
    if !try(local.addon_install[p.override], false) && var.common_policy_installation[k]
  }
}
