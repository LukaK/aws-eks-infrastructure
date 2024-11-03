# Cluster Autoscaler Examples

Examples that demonstrate worker node scaling with cluster autoscaler.
For more information see [link](./README.md#cluster-autoscaler)

Deploy examples with `kubectl apply -k .`.

## Simple autoscaler

Simple deployment of 50 pods.

After deploying resources some of the pods will be in pending state, and that will trigger scale up event for cluster autoscaler.
After a couple of minutes new node will be added to your worker nodes and remaining pods will be scheduled on the new node.

Resources are deployed to `cluster-autoscaller-simple-autoscaler` namespace.

<p align="center">
    <img title="Cluster Autoscaler Scaling Up" alt="Cluster autoscaler scaling up" src="../../assets/cluster-autoscaler-simple-1.png">
</p>
<p align="center">
    <em>Fig. Cluster autoscaler preparing to scale</em>
</p>

<p align="center">
    <img title="Cluster Autoscaler Green" alt="Cluster autoscaler green" src="../../assets/cluster-autoscaler-simple-2.png">
</p>

<p align="center">
    <em>Fig. Cluster autoscaler, scaling complete</em>
</p>

Delete the resources and wait for 10 min for the scale down event to trigger, reducing number of worker nodes to their original size.
