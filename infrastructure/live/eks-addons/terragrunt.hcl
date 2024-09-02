terraform {
  source = "../../modules/eks-addons"
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
    cluster_name                      = "demo"
    cluster_endpoint                  = "demo"
    cluster_version                   = "1.29"
    oidc_provider_arn                 = "arn:aws:iam::123456789012:oidc-provider"
    cluster_primary_security_group_id = "sg-1234"
    node_security_group_id            = "sg-1234"
  }
}

dependency "vpc" {
  config_path = "../vpc/"

  mock_outputs = {
    private_subnets = ["subnet-1234", "subnet-5678"]
  }
}

inputs = {

  cluster_name      = dependency.eks.outputs.cluster_name
  cluster_endpoint  = dependency.eks.outputs.cluster_endpoint
  cluster_version   = dependency.eks.outputs.cluster_version
  oidc_provider_arn = dependency.eks.outputs.oidc_provider_arn

  # self managed addons
  enable_aws_efs_csi_driver           = true
  enable_aws_load_balancer_controller = true
  enable_metrics_server               = true
  enable_cluster_autoscaler           = true

  tags = local.tags

  # efs storage configuration
  efs_storage_configuration = {
    storage_class_name                  = "efs"
    storage_class_directory_permissions = "700"
    subnet_ids                          = dependency.vpc.outputs.private_subnets
    security_group_ids                  = [dependency.eks.outputs.cluster_primary_security_group_id, dependency.eks.outputs.node_security_group_id]
  }

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
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command = "aws"
      args = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.eks.name]
    }
  }
}

provider kubernetes {
  host = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command = "aws"
    args = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.eks.name]
  }
}
EOF
}

