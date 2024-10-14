terraform {
  source = "../../modules/users-iam"
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

inputs = {
  cluster_name = dependency.eks.outputs.cluster_name

  # tags
  tags = local.tags
}
