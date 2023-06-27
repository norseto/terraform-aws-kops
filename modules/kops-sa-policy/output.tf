output "policy_list" {
  description = <<_EOM
    list of policies created. Can be userd as value of
    service_account_external_permissions parameter of kops-cluster
  _EOM
  value = values({ for n in keys(local.policies) :
    n => {
      name : local.policies[n].name
      namespace : local.policies[n].namespace
      policy_arns : [module.aws_policies[n].arn]
      override : local.policies[n].override
    }
  })
}
