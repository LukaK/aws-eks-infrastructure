terraform {
  source = "tfr:///terraform-aws-modules/vpc/aws?version=5.13.0"
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


inputs = {
  name = local.configuration.vpc_name
  cidr = local.configuration.vpc_cidr

  azs             = local.configuration.vpc_azs
  private_subnets = local.configuration.vpc_private_subnets
  public_subnets  = local.configuration.vpc_public_subnets

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  public_subnet_tags = {
    "kubernetes.io/role/elb"                                    = 1
    "kubernetes.io/cluster/${local.configuration.cluster_name}" = "owned"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"                           = 1
    "kubernetes.io/cluster/${local.configuration.cluster_name}" = "owned"
  }

  tags = local.tags
}
