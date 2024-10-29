terraform {
  source = "../../modules/dns"
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
  tags        = local.tags
  domain_name = "lukakrapic.com"
}
