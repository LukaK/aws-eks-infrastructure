# Horizontal Pod Autoscaler

Secrets manager is used to mount secret information to pod as files or as environment variables.
Currently there is no support for pod identity so when installing add-on role is created with permissions to retrieve any secret and that can be assumed by any service account in the cluster.
Restrict permissions as needed.

Example is not deployed as part of ArgoCD applications since it requires manual intervention for now.

## Basic Example

Basic example deploys everything in `secrets-manager-example-basic-example` namespace.

Setup:
1. Create a secrets in aws account
2. Add secret in `basic-example.yaml` file under `SECRET-NAME`
3. Retrieve output of add-on stack `application_secrets_role_arn`
4. Add role arn to `basic-example.yaml` file under `ROLE-ARN`
5. Deploy the example `kubectl apply -f .`

Check that the pod has access to the secrets
```bash
# retrieve pod information
kubectl get pod -n  secrets-manager-example-basic-example

# enter the container
kubectl exec -it -n secrets-manager-example-basic-example POD-NAME -- /bin/bash

# check if secrets are available as files
ls /mnt/secrets

# check if environment variables are set
env | grep MY_
```
