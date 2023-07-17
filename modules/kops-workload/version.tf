terraform {
  required_version = ">= 1.3"
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.9.0"
    }
    kops = {
      source  = "eddycharly/kops"
      version = ">= 1.25.3"
    }
  }
}
