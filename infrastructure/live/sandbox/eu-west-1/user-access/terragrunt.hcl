terraform {
  source = "../../../../modules/users-iam"
}


# include root configuration, holds components and configurations shared across all modules
include "root" {
  path   = find_in_parent_folders()
  expose = true
}

# construct local variables
locals {
  tags = merge(include.root.inputs.tags, { Stack = "User Access" })
}

dependency "eks" {
  config_path = "../eks/"

  mock_outputs = {
    cluster_name = "demo"
  }
}


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

inputs = {
  cluster_name = dependency.eks.outputs.cluster_name

  # tags
  tags = local.tags
}
