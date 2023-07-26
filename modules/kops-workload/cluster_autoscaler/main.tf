/**
 * Delete node affinity if all nodes are spot-instance.
 */
# Patch pod-identity-webhook so that cert-manager can be deployed.
resource "null_resource" "patch" {
  count = local.create ? 1 : 0
  triggers {
    config_raw = var.kubeconfig_raw
  }
  provisioner "local-exec" {
    command = <<_EOM
    KUBECONFIG=./kubeconfig.$$
    echo '${self.triggers.config_raw}' > $KUBECONDIF
    kubectl --kubeconfig $KUBECONFIG -n kube-system patch --type=json deploy/cluster-autoscaler -p='[{"op": "replace", \
    "path": "/spec/template/spec/affinity/nodeAffinity/requiredDuringSchedulingIgnoredDuringExecution/nodeSelectorTerms/0/matchExpressions/0/key", \
    "value": "node-role.kubernetes.io/control-plane"}]'
    rm -f $KUBECONFIG
    _EOM
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<_EOM
    KUBECONFIG=./kubeconfig.$$
    echo '${self.triggers.config_raw}' > $KUBECONDIF
    kubectl --kubeconfig $KUBECONFIG -n kube-system patch --type=json deploy/cluster-autoscaler -p='[{"op": "replace", \
    "path": "/spec/template/spec/affinity/nodeAffinity/requiredDuringSchedulingIgnoredDuringExecution/nodeSelectorTerms/0/matchExpressions/0/key", \
    "value": "node-role.kubernetes.io/spot-worker"}]'
    rm -f $KUBECONFIG
    _EOM
  }
}
