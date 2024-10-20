# Eks with Terraform and Terragrunt

Project holds resources for deploying production ready aws eks cluster with plugins.
Project is deployed as a terraform project with terragrunt to orchestrate the deployment.

Project is deployed in four stack; networking, eks cluster, eks add-ons and storage.
All the files for terragrunt deployment are in `infrastructure/live` folder.
Terraform modules are in the project in `infrastructure/modules` directory.

Extra terraform resources for cluster workings are in `services` directory and examples for testing plugins are in `examples` directory.

Directory structure is shown below.

```bash
├── README.md
├── assets                  # documentation assets
|
├── examples                # EXAMPLES
│   ├── alb                 # load balancer example
│   ├── cluster-autoscaler  # cluster autoscaler example
│   ├── ebs-csi             # ebs storage example
│   ├── efs                 # efs storage example
│   └── hpa                 # horizontal pod autoscaler example
|
├── infrastructure          # INFRASTRUCTURE
│   ├── live
│   │   ├── addons          # eks add-ons stack
│   │   ├── devenv.hcl      # dev environment specific overrides
│   │   ├── eks             # eks stack
│   │   ├── env.hcl         # default environment configuration
│   │   ├── storage         # storage stack
│   │   ├── terragrunt.hcl  # root terragrunt configuration
│   │   ├── user-access     # cluster user access stack ( admins, viewers )
│   │   └── vpc             # networking stack
|   |
│   └── modules             # TERRAFORM MODULES
│       ├── addons          # eks add-ons instalation
│       ├── storage         # efs resources
│       └── users-iam       # resources for user access management
|
└── services                # additional cluster resources deployed with manifests
    ├── storage-classes
    └── users-iam
```

## Deployment

Ensure you have the following requirements met:
- terraform installed
- terragrunt installed
- aws account
- aws account cli access


By default resources are deployed in `eu-west-1` region.
To deploy the infrastructure run the commands below.
It will take some time to deploy the resources.
```bash
pushd infrastructure/live
terragrunt run-all apply
popd
```


Update your local `.kube/config` file.
```bash
aws eks update-kubeconfig --name demo --region eu-west-1
```

Deploy additional resources to the cluster.
```bash
kubectl apply --recursive -f services/
```

## Network Stack

Network is configured with two public subnets and two private subnets.
Only one nat gateway is deployed in one of the public subnets to routes the internet traffic from both private subnets.

**Network CIDR block:** 10.0.0.0/16


| **Subnet**              | **CIDR Block**                |
|---------------------|-------------------------------|
| **Private Subnet #1**   | 10.0.0.0/19                   |
| **Private Subnet #2**   | 10.0.32.0/19                  |
| **Public Subnet #1**    | 10.0.64.0/19                  |
| **Public Subnet #2**    | 10.0.96.0/19                  |


## Cluster Configuration

When deployed, aws creates control plane on aws account and network interfaces in public or private subnets depending on the access mode.

Cluster is deployed with both public and private access allowing administration from the internet and private access from the worker nodes.

Worker nodes are deployed as on demand managed node group with a pool of instance types.
For more details about the cluster configuration see `infrastructure/live/env.hcl`.


<p align="center">
    <img title="Eks architecture" alt="Eks architecture" width="75%" src="./assets/eks-architecture.png">
</p>

## Storage Stack

Contains resources defined in `storage` terraform module.

It deploys efs file system and mount targets in private subnets so that worker nodes can mount the file system with efs csi driver.
It also contains kubernetes storage class resource.


## User Access Stack

Contains resources is `users-iam` module and contains resources for granting permissions to users.

For admin users it create admin iam role and links it to admin cluster group using eks api.
Admin iam group is created as well with permissions to assume the admin role, to easily add new users.

For viewers it creates viewer iam role and binds it to the viewer group using eks api.
Viewer iam group is created as well with permission to assume the viewer role, to easily add new users.

In eks, permissions for admin and viewer group is granted with cluster role and cluster role binding.
They are defined in `services/users-iam` and are not deployed with the terraform resources.

### How to grant admin/viewer permissions

1. Create the user with command line access
2. Assign the user to the `admin/viewer` iam group
3. Send corresponding role arn to the user
4. User assumes the role and updates its local `.kube/config` file

### How to assume the role and update local kube config file

Validate if you can assume the target role.
```bash
aws sts assume-role --role-arn ROLE-ARN --role-session-name SOME-NAME --profile BASE-PROFILE
```

Create new profile manually in `.aws/config` from your base user credentials.
```text
[profile PROFILE-NAME]
source_profile = BASE-PROFILE
role_arn = ROLE-ARN
```

Update local kube config file.
```bash
aws eks update-kubeconfig --name demo --region eu-west-1 --profile PROFILE-NAME
```

## Cluster Add-ons Stack

Cluster is deployed with a set of controllers that are shown below.
Controllers are deployed with helm charts or if supported as a cluster add on managed by aws.

List of add-ons:
- pod identity
- metric server
- cluster autoscaler
- ebs csi driver
- efs csi controller
- load balancer controller

### Pod identity

Pod identity is one of the options for granting access to pods to access aws resources.
It is deployed as a `DaemonSet` to all the worker nodes.
Before using, check if it is applicable for your case in aws documentation.

Pod identity is deployed as a eks add-on with the latest version at the time of writing the project.
To update the version find out the latest version of the add-on and update the module parametar value.

Find out pod identity add-on version.
```bash
aws eks describe-addon-versions --region eu-west-1 --addon-name eks-pod-identity-agent
```

### Metric Server

Metric server is a controller that is used to determine cpu and memory utilization by nodes and pods.
It is used by pod autoscaler for scaling pods horizontally or vertically.

For more advanced scaling use cases based on latency, traffic, saturation or errors substitute metric server for prometheus or keda.

Metric server is installed with helm and the latest version at the time of writing.
To upgrade the version of metric server use the command below to find out the new version and update the corresponding module parametar.

```bash
helm repo add metric-server https://kubernetes-sigs.github.io/metrics-server/
helm repo update
helm search repo metric-server metric-server
```

To see default chart values use the command below.
```bash
helm show-values metric-server/metric-server --version VERSION
```

### Cluster Autoscaler

Controller used for scaling in/out managed worker nodes based on the cluster load.
To use cluster autoscaler metric server needs to be installed.

It uses aws autoscaling groups for scaling the worker nodes.
When managed worker nodes are created you define minimum, maximum and desired size of the worker node group.

Examples on cluster autoscaler can be found [here](./examples/cluster-autoscaler).

Cluster autoscaler is installed with helm and the latest version at the time of writing.
To upgrade the version use the command below to find out the new version and update the corresponding module parametar.

```bash
helm repo add autoscaler https://kubernetes.github.io/autoscaler
helm repo update
helm search repo autoscaler cluster-autoscaler
```

To see default chart values use the command below.
```bash
helm show-values autoscaler/cluster-autoscaler --version VERSION
```

### Ebs Csi Driver

Controller responsible for providing the interface to aws ebs volumes.
After controller is installed you are able to provision persistent volumes backed by ebs drives directly or dynamically with persistent volume claims.

Ebs backed persistent volumes support only `ReadWriteOnce` mode and are tied to one availability zone.

Examples on ebs csi driver can be found [here](./examples/ebs-csi/).
Files in `services/storage-classes` hold custom storage classes for the cluster.

Ebs csi driver is deployed as a eks add-on with the latest version at the time of writing the project.
To update the version find out the latest version of the add-on and update the module parametar value.
```bash
aws eks describe-addon-versions --region eu-west-1 --addon-name aws-ebs-csi-driver
```

### Efs Csi Controller

Controller responsible for mounting highly available efs volumes to the pods.
Like with ebs controller you are able to provision persistent volume objects directly or with persistent volume claims.

Controller will not allocate new efs drives, it will only mount existing drives and make it available to the pod.
Persistent volumes backed by efs support `ReadWriteMany` option.

Examples on using efs csi controller can be found [here](./examples/efs/)

Efs csi controller is installed with helm and the latest version at the time of writing.
To upgrade the version use the command below to find out the new version and update the corresponding module parametar.

```bash
helm repo add efs-csi https://kubernetes-sigs.github.io/aws-efs-csi-driver/
helm repo update
helm search repo efs-csi aws-efs-csi-driver
```

To see default chart values use the command below.
```bash
helm show-values efs-csi/aws-efs-csi-driver --version VERSION
```

### Load Balancer Controller

Controller responsible for managing cloud resources for ingress and service objects.

When service of type `LoadBalancer` is created, controller will provision network load balancer.
For every service of type `LoadBalancer` one network load balancer is provisioned.

When ingress object is defined, controller will provision application load balancer.
To keep number of application load balancers down, define ingress groups.
Every ingress group maps to one application load balancer.

Examples on load balancer controller can be found [here](./examples/alb/)

Annotations used with network load balancer can be found [here](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.7/guide/service/annotations/).

Annotations used with ingress can be found [here](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.7/guide/ingress/annotations/).


Load balancer controller is installed with helm and the latest version at the time of writing.
To upgrade the version use the command below to find out the new version and update the corresponding module parametar.

```bash
helm repo add eks-charts https://aws.github.io/eks-charts
helm repo update
helm search repo eks-charts aws-load-balancer-controller
```

To see default chart values use the command below.
```bash
helm show-values eks-charts/aws-load-balancer-controller --version VERSION
```
## Examples

Deploy the examples.
```bash
kubectl apply --recursive -f examples/
```
## Cleanup
```bash
# delete examples
kubectl delete --recursive -f examples/

# delete services
kubectl delete --recursive -f services/

# delete infrastructure
pushd ./infrastructure/live
terragrunt run-all destroy
popd
```
