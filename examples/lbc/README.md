# Load Balancer Controller


Examples demonstrating provisioning of aws load balancers with load balancer controller.
For more information see [link](./README.md#load-balancer-controller)

Deploy examples with `kubectl apply -f .`.
Wait a couple of minutes for load balancer to get in the `Active` state looking in the aws console.
All examples are deployed in `lbc-examples` namespace.

## Network load balancer

With service type of `LoadBalancer`, network load balancer is deployed.

Wait for the load balancer to be deployed and in ready state.

```bash
kubectl get vsc -n lbc-examples
```

Test if the dns is resolving ok.

```bash
nslookup ENDPOINT
```

Test if you can connect to the service from your computer.

```bash
curl -i http://ENDPOINT:80
```

ADD IMAGE

## Ingress

When you create ingress rule of class `alb`, application load balancer is created.

Get ingress public address and check that it is resolving ok.

<img title="Public http access" alt="alb public http access" src="../../assets/alb-public-http.png">

Check that you can access the service in web browser or using

```bash
curl -i --header "Host: test.lukak.com" http://ENDPOINT:80
```
