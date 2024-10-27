# Nginx External Ingress

Wait until `Address` field is populated in the ingress and get the value.
```bash
kubectl get ingress -n nginx-external-example
```

To test the example use
```bash
curl -i --header "Host: test.lukakrapic.com" http://ADDRESS
```
