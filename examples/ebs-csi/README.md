# Elastic Block Storage Examples

Examples with persistent storage backed by ebs volumes.
For more informatio see [link](/README.md#ebs-csi-driver)

Deploy examples with `kubectl apply -k .`.

## Simple Ebs

Dynamic allocation of ebs storage with pvc to one pod.
Resources are deployed to `ebs-example-simple-ebs` namespace.

Check that the pod is running and that volume is successfully attached.

<p align="center">
    <img title="Simple ebs example" alt="Simple ebs example" src="../../assets/ebs-simple.png">
</p>
<p align="center">
    <em>Fig. Ebs csi, simple example</em>
</p>
