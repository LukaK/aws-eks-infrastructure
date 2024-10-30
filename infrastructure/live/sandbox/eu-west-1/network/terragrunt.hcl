terraform {
  source = "../../../../modules/network"
}

# include root configuration, holds components and configurations shared across all modules
include "root" {
  path   = find_in_parent_folders()
  expose = true
}

# include common configurations and expose the values to be able to reference them in this configuration
include "accounts" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/accounts.hcl"
  expose = true
}

include "cluster" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/cluster.hcl"
  expose = true
}

include "domain" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/domain.hcl"
  expose = true
}

# construct local variables
locals {
  tags = merge(include.root.inputs.tags, { Stack = "Eks Cluster" })
}

# override providers to include aliased provider for network resource deployment
generate "provider_override" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${include.root.locals.aws_region}"

  # Only these AWS Account IDs may be operated on by this template
  allowed_account_ids = ["${include.root.locals.account_id}"]
  assume_role {
    role_arn = "${include.root.locals.assume_role}"
  }
}


provider "aws" {
  region = "${include.root.locals.aws_region}"
  alias = "network"

  # Only these AWS Account IDs may be operated on by this template
  allowed_account_ids = ["${include.accounts.locals.network_account.account_id}"]
  assume_role {
    role_arn = "${include.accounts.locals.network_account.assume_role}"
  }
}
EOF
}


inputs = {
  cluster_name = include.cluster.locals.cluster_name

  # vpc configuration
  vpc_name        = include.cluster.locals.vpc_name
  cidr            = include.cluster.locals.vpc_cidr
  azs             = include.cluster.locals.vpc_azs
  private_subnets = include.cluster.locals.vpc_private_subnets
  public_subnets  = include.cluster.locals.vpc_public_subnets

  # nat gateway configuration
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  # dns configuration
  sub_domain_name          = include.domain.locals.sub_domain_name
  primary_zone_id          = include.domain.locals.primary_zone_id
  primary_zone_record_name = include.domain.locals.primary_zone_record_name

  tags = local.tags
}
