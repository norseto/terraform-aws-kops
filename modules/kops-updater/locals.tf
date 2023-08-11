locals {
  # When revision is all 1, api endpoint may not yet exist.
  new_cluster = length([for k, v in var.keepers : k if v > 1]) < 1
}
