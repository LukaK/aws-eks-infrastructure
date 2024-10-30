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

inputs = {
  cluster_name = dependency.eks.outputs.cluster_name

  # tags
  tags = local.tags
}
