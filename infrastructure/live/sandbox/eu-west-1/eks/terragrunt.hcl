terraform {
  source = "tfr:///terraform-aws-modules/eks/aws?version=20.24.0"
}

# include root configuration, holds components and configurations shared across all modules
include "root" {
  path   = find_in_parent_folders()
  expose = true
}

# include common configurations and expose the values to be able to reference them in this configuration
include "cluster" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/cluster.hcl"
  expose = true
}

# construct local variables
locals {
  tags = merge(include.root.inputs.tags, { Stack = "Eks Cluster" })
}


dependency "vpc" {
  config_path = "../network/"

  mock_outputs = {
    vpc_id          = "test-id"
    private_subnets = ["subnet-1234", "subnet-5678"]
  }
}

inputs = {
  cluster_name    = include.cluster.locals.cluster_name
  cluster_version = include.cluster.locals.cluster_version

  # public & private access
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  # create openId connect provider for secrets manager plugin
  enable_irsa = true

  # network information with subnets where nodes will be created
  vpc_id     = dependency.vpc.outputs.vpc_id
  subnet_ids = dependency.vpc.outputs.private_subnets

  # add amin permissions
  enable_cluster_creator_admin_permissions = true

  # managed node groups
  eks_managed_node_group_defaults = include.cluster.locals.eks_managed_node_group_defaults
  eks_managed_node_groups         = include.cluster.locals.eks_managed_node_groups

  # additional rules for worker node security group
  node_security_group_additional_rules = include.cluster.locals.node_security_group_additional_rules

  # tags
  tags = local.tags
}
