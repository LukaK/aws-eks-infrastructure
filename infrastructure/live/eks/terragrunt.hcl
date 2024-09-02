terraform {
  source = "tfr:///terraform-aws-modules/eks/aws?version=20.24.0"
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


dependency "vpc" {
  config_path = "../vpc/"

  mock_outputs = {
    vpc_id          = "test-id"
    private_subnets = ["subnet-1234", "subnet-5678"]
  }
}

inputs = {
  cluster_name    = local.configuration.cluster_name
  cluster_version = local.configuration.cluster_version

  # add public access
  cluster_endpoint_public_access = true

  # create oidc provider for the cluster
  enable_irsa = true

  # network information with subnets where nodes will be created
  vpc_id     = dependency.vpc.outputs.vpc_id
  subnet_ids = dependency.vpc.outputs.private_subnets

  # add amin permissions
  enable_cluster_creator_admin_permissions = true

  # managed node groups
  eks_managed_node_group_defaults = local.configuration.eks_managed_node_group_defaults
  eks_managed_node_groups         = local.configuration.eks_managed_node_groups

  # tags
  tags = local.tags
}
