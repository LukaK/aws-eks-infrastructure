# Deployment Instructions

Steps:
- [setting up user profiles](#setting-up-user-profiles)
- [populating common values](#populating-common-values)
- [deploying stacks](#deploying-stacks)

## Setting Up User Profiles

Ensure you have base and sandbox admin profile in you aws configuration.
Example of the `.aws/config` file is below.
```txt
[profile developer-base]
region = eu-west-1
output = json

[profile developer-sandbox-admin]
source_profile = developer-base
role_arn = SANDBOX-DEPLOYMENT-ROLE-ARN
```

Corresponding `.aws/credentials` file is below.
```txt
[developer-base]
aws_access_key_id = ACCESS-KEY
aws_secret_access_key = SECRET-ACCESS-KEY
```

## Populating Common Values

Create `accounts.hcl` and `domain.hcl` in `infrastructure/_envcommon` directory.
```bash
cd infrastructure/_envcommon
cp accounts-template.hcl accounts.hcl
cp domain-template.hcl domain.hcl
```

File `accounts.hcl` holds information about the network and sandbox account.
Sandbox account holds the infrastructure and network account holds the root domains.
If they are one and the same account just repeat the information in both sections.

```hcl
locals {

  network_account = {
    account_name = "Network"
    account_id   = ""
    assume_role  = ""
  }

  sandbox_account = {
    account_name = "Sandbox"
    account_id   = ""
    assume_role  = ""
  }
}
```

File `domain.hcl` holds information about the root domain, located in network account, and about the subdomain for the cluster resources that is deployed in sandbox account.
It also holds information about the notification email where issues about certificate renewals are sent.
```hcl
locals {
  sub_domain_name          = "api.DOMAIN"
  primary_zone_record_name = "api"
  primary_zone_id          = ""
  notification_email       = ""
}
```

## Deploying Stacks

Use `developer-base` profile to deploy the resources. It will take some time to deploy all the resources.
```bash
pushd infrastructure/live
AWS_PROFILE=developer-base terragrunt run-all apply
popd
```
