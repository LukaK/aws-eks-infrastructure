resource "helm_release" "argocd" {
  name = "argocd"

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.argocd_chart_version

  namespace        = "argocd"
  create_namespace = true
  values = [
    templatefile("values/argocd.yaml", {
      hosted_zone_name    = var.hosted_zone_name
      ingress_class_name  = local.external_ingress_class_name
      cluster_issuer_name = local.cluster_issuer_name
    })
  ]

  depends_on = [helm_release.cert-manager, helm_release.external_dns, helm_release.external_nginx]
}
