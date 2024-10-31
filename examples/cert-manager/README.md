# Cert manager

Wait for a couple of minutes until certificate is ready.

```bash
# get certificate
kubectl get certificate -n cert-manager-example

# get details about the certificate
kubectl describe certificate -n cert-manager-example

# describe certificate request
kubectl describe CertificateRequest -n cert-manager-example

# describe order that is created by certificate request
kubectl describe Order -n cert-manager-example

# describe challenge that is created by the order
kubectl describe Challenge -n cert-manager-example
```
