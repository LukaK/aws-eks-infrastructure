terraform {
  source = "../../modules/addons"
}

include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path           = find_in_parent_folders("env.hcl")
  expose         = true
  merge_strategy = "no_merge"
}

include "env_override" {
  path           = find_in_parent_folders("${get_env("ENVIRONMENT", "")}env.hcl")
  expose         = true
  merge_strategy = "no_merge"

}

locals {
  configuration = merge(include.env.locals, include.env_override.locals)
  tags          = merge(include.env.locals.tags, include.env_override.locals.tags)
}

dependency "eks" {
  config_path = "../eks/"

  mock_outputs = {
    cluster_name = "demo"
  }
}

inputs = {
  cluster_name = dependency.eks.outputs.cluster_name
  tags         = local.tags
}


generate "helm_provider" {
  path      = "providers.tf"
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

