# include root configuration, holds components and configurations shared across all modules
include "root" {
  path   = find_in_parent_folders()
  expose = true
}

include "domain" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/domain.hcl"
  expose = true
}

# source the terraform module
terraform {
  source = "../../../../modules/addons"
}

# construct local variables
locals {
  tags = merge(include.root.inputs.tags, { Stack = "Eks Addons" })
}


# generate helm provider
generate "helm_provider" {
  path      = "helm_provider.tf"
  if_exists = "overwrite_terragrunt"

  contents = <<EOF
data "aws_eks_cluster" "eks" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "eks" {
  name = var.cluster_name
}

provider "helm" {
  kubernetes {
    host = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token = data.aws_eks_cluster_auth.eks.token
  }
}
EOF
}


dependency "eks" {
  config_path = "../eks/"

  mock_outputs = {
    cluster_name      = "demo"
    oidc_provider_arn = "test"
    oidc_provider_url = "test"
  }
}

dependency "vpc" {
  config_path = "../network/"

  mock_outputs = {
    hosted_zone_id   = "123asdfa"
    hosted_zone_name = "test hosted zone"
  }
}

# override inputs from the root and add additional inputs to the module
inputs = {
  tags                            = local.tags
  cluster_name                    = dependency.eks.outputs.cluster_name
  hosted_zone_id                  = dependency.vpc.outputs.hosted_zone_id
  hosted_zone_name                = dependency.vpc.outputs.hosted_zone_name
  cert_manager_notification_email = include.domain.locals.notification_email
  openid_connect_arn              = dependency.eks.outputs.oidc_provider_arn
  openid_connect_url              = dependency.eks.outputs.oidc_provider
}
