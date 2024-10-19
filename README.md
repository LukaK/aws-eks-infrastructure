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
├── examples                # examples directory
│   ├── alb
│   ├── cluster-autoscaler
│   ├── ebs-csi
│   ├── efs
│   └── hpa
├── infrastructure          # infrastructure
│   ├── live
│   │   ├── addons          # eks add-ons stack
│   │   ├── devenv.hcl      # dev environment specific overrides
│   │   ├── eks             # eks stack
│   │   ├── env.hcl         # default environment configuration
│   │   ├── storage         # storage stack
│   │   ├── terragrunt.hcl  # root terragrunt configuration
│   │   ├── user-access     # cluster user access stack ( admins, viewers )
│   │   └── vpc             # networking stack
│   └── modules
│       ├── addons          # eks add-ons instalation
│       ├── storage         # efs resources
│       └── users-iam       # resources for user access management
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
pushd services/storage-classes && kubectl
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

## User Access Stack

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

For more advanced scaling use cases based on latency substitute metric server for prometheus.
Also for scaling based on the event queue see LINK.

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

TODO:
- Check for what is the metric server requirement
- check more useful metrics
- check how to scale on queue events


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
Todo:
- check if the metric server is the requirement


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

## User Access

TODO: Add image

After cluster is installed and configured, additional resources are added for admin and viewer user access.

Two user groups are added `admins` and `viewers`.
Admins have permission to assume admin eks role.
Admin eks role has admin access to eks cluster and is linked to admin group in kubernetes cluster using EKS API.
Viewers have analogous resources but with limited permissions.

Kubernetes resources are in `services/users-iam`.
They are deployed automatically with ArgoCD ( TODO ).




## Examples

Deploy examples one by one or all at once.
Every example has a `README.md` file with instructions.
```bash
kubectl apply -f examples/
```

## Add-ons


### How to grant admin/viewer permissions

1. Create the user and create cli credentials
2. Assign the user to the `admin` group for the eks cluster
3. Send corresponding role arn to the user
4. User updates its local kube config file with the assumed role

### How to assume the role

Validate if the user can assume the target role with following command.
```bash
aws sts assume-role --role-arn ROLE-ARN --role-session-name some-name --profile BASE-PROFILE
```

After validating, create profile manually in `.aws/config` like below.
You will assume temporary credentials from the role using base profile to retrieve them.
```text
[profile test-eks-user-viewer]
role_arn = ROLE-ARN
source_profile = BASE-PROFILE
```

### How to update local kube config file

Use the following command.
```bash
aws eks update-kubeconfig --name CLUSTER-NAME --region REGION --profile PROFILE
```

## Horizontal Pod Autoscaler

Prepare shells for monitoring.

```bash
# shell 1: watch number of pods
kubectl get deployment -n hpa-example --watch

# shell 2; watch horizontal pod autoscaler metrics
kubectl get hpa -n hpa-example --watch
```

To trigger the auto scaling event execute the following command.

```bash
kubectl run -i --tty load-generator --rm --image=busybox:1.28 --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://myapp.hpa-example.svc.cluster.local; done"
```

After the load reduces pods will scale down in 5-10 minutes.

## Cleanup
```bash
# cleanup examples
kubectl delete --recursive -f examples/

# cleanup aws resources
pushd ./infrastructure/live
terragrunt run-all destroy
popd
```
