# Nginx Ingress

Wait until `Address` field is populated in the ingress and get the value.
```bash
kubectl get ingress -n nginx-external-example
```

Ingress using public ingress class should have `Address` of public load balancer and private ingress of private load balancer.

Test the public ingress.
```bash
curl -i --header "Host: test.lukakrapic.com" http://PUBLIC-ADDRESS
```
