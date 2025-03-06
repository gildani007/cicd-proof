# providers.tf
terraform {
  required_version = "~> 1.6.6"
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.17.0"  # Set your required minimum version
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"  # Set appropriate version
    }
  }
}
