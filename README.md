# Terraform eks deployment

Terragrunt and terraform resources for deploying production ready EKS cluster with controllers.


## Architecture

<p align="center">
    <img title="Eks architecture" alt="Eks architecture" width="75%" src="./assets/eks-architecture.png">
</p>

Network spans two public and two private subnets across two availability zones.
Cluster is deployed with public and private access allowing administrators access form the internet and private access for worker nodes.

Worker nodes are deployed as part of a managed node group into private subnets.
One nat gateway is deployed in public subnet for providing internet access to the worker nodes.

Cluster is deployed with a set of controllers that are shown [below](#add-ons).

## Deployment

Ensure you have aws command line access to an aws account.
Terraform, terragrunt should be installed as well.
Run the commands below to provision the cluster.

```bash
pushd ./infrastructure/live
terragrunt run-all apply
popd
```

Update you `kubectl` credentials.

```bash
aws eks update-kubeconfig --name demo -region eu-west-1
```

Examples are in `examples` folder.
Every example section has its own namespace. Deploy the examples.
```bash
# deploy examples
kubectl apply --recursive -f examples/
```

## Add-ons

List of deployed controllers:
- ebs csi driver
- efs controller
- alb controller
- metric server
- cluster autoscaler


### Ebs Controller

Responsible for providing the interface to aws ebs volumes.
After controller is installed you are able to provision persistent volumes backed by ebs drives directly or dynamically with persistent volume claims.

Ebs backed persistent volumes support only `ReadWriteOnce` mode and are tied to one availability zone.

Examples can be found [here](./examples/ebs-csi/)


### Efs Controller

Responsible for mounting highly available efs volumes to the pods.
Like with ebs controller you are able to provision persistent volume objects directly or with persistent volume claims.

Controller will not allocate new efs drives, it will only mount existing drives and make it available to the pod.
Persistent volumes backed by efs support `ReadWriteMany` option.

Examples can be found [here](./examples/efs/)

### Alb Controller

Responsible for managing cloud resources for ingress and service objects.

When service of type `LoadBalancer` is created, controller will provision network load balancer.
For every service of type `LoadBalancer` one network load balancer is provisioned.

When ingress object is defined, controller will provision application load balancer.
To keep number of application load balancers down, define ingress groups. Every ingress group maps to one application load balancer.

Examples can be found [here](./examples/alb/)

### Cluster Autoscaler

Responsible for adjusting worker node count based on the cluster load.
Needs metric server to be installed.

Examples can be found [here](./examples/cluster-autoscaler).


## Cleanup
```bash
# cleanup examples
kubectl delete --recursive -f examples/

# cleanup aws resources
pushd ./infrastructure/live
terragrunt run-all destroy
popd
```
