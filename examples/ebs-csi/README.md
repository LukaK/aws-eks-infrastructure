# Elastic Block Storage Examples

Deploy examples with `kubectl apply -f .`.
All examples are deployed in `ebs-examples` namespace.

## Simple ebs

Dynamic allocation of ebs storage with pvc to one pod.
Ebs volumes are `ReadWriteOnce` and only one pod can mount the volume.

Check that the pod is running and that volume is successfully attached.

<img title="Public http access" alt="alb public http access" src="../../assets/ebs-simple.png">
