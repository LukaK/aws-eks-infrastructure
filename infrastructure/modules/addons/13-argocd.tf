resource "helm_release" "argocd" {
  name = "argocd"

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.argocd_chart_version

  namespace        = "argocd"
  create_namespace = true
  values           = [file("values/argocd.yaml")]

  depends_on = [helm_release.cert-manager, helm_release.external_dns, helm_release.external_nginx]
}
