# How To Add Admin/Viewer User

1. Create the user with command line access
2. Assign the user to the `admin/viewer` iam group
3. Send corresponding role arn to the user
4. User assumes the role and updates its local `.kube/config` file

## How to assume the role and update local kube config file

Validate if you can assume the target role.
```bash
aws sts assume-role --role-arn ROLE-ARN --role-session-name SOME-NAME --profile BASE-PROFILE
```

Create new profile manually in `.aws/config` from your base user credentials.
```txt
[profile PROFILE-NAME]
source_profile = BASE-PROFILE
role_arn = ROLE-ARN
```

Update local kube config file.
```bash
aws eks update-kubeconfig --name demo --region eu-west-1 --profile PROFILE-NAME
```
