include "accounts" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/accounts.hcl"
  expose = true
}

locals {
  account_name = include.accounts.locals.sandbox_account.account_name
  account_id   = include.accounts.locals.sandbox_account.account_id
  assume_role  = include.accounts.locals.sandbox_account.assume_role
}
