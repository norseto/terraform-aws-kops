include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path   = "${get_terragrunt_dir()}/../../../_env/sg/internal.hcl"
  expose = true
}
