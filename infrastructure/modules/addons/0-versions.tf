terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.63"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.16.0"
    }
  }
}
