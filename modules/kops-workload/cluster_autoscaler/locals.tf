locals {
  create     = var.create.install
  path       = "/spec/template/spec/affinity/nodeAffinity/requiredDuringSchedulingIgnoredDuringExecution/nodeSelectorTerms/0/matchExpressions/0/key"
  role_cp    = "node-role.kubernetes.io/control-plane"
  role_sp    = "node-role.kubernetes.io/spot-worker"
  config_raw = var.create.kubeconfig_raw
}
