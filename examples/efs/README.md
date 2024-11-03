# Elastic File System Storage Examples

Examples with persistent storage backed by efs.
For more information see [link](./README.md#efs-csi-controller)

Deploy examples with `kubectl apply -k .`.

## Simple Efs

Demonstrating mounting of efs storage with pvc on multiple pods.

Efs volumes support `ReadWriteMany` and can be mounted on multiple pods at the same time.

Check that the pod is running and that volume is successfully attached.
Resources are deployed in `efs-example-simple-efs` namespace.

CHANGE IMAGE
<img title="Public http access" alt="alb public http access" src="../../assets/efs-simple.png">
