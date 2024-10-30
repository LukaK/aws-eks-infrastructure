terraform {
  source = "../../../../modules/storage"
}

# include root configuration, holds components and configurations shared across all modules
include "root" {
  path   = find_in_parent_folders()
  expose = true
}

locals {
  tags = merge(include.root.inputs.tags, { Stack = "Storage" })
}

dependency "eks" {
  config_path = "../eks/"

  mock_outputs = {
    cluster_name                      = "demo"
    cluster_primary_security_group_id = "sg-1234"
    node_security_group_id            = "sg-1234"
  }
}

dependency "vpc" {
  config_path = "../network/"

  mock_outputs = {
    private_subnets = ["subnet-1234", "subnet-5678"]
  }
}

inputs = {
  tags         = local.tags
  cluster_name = dependency.eks.outputs.cluster_name
  efs_storage_configuration = {
    storage_class_name                  = "efs"
    storage_class_directory_permissions = "700"
    subnet_ids                          = dependency.vpc.outputs.private_subnets
    security_group_ids                  = [dependency.eks.outputs.cluster_primary_security_group_id, dependency.eks.outputs.node_security_group_id]
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

provider kubernetes {
  host = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token = data.aws_eks_cluster_auth.eks.token
}
EOF
}

