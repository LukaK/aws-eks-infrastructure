resource "helm_release" "internal_nginx" {
  name = "internal-nginx"

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = var.nginx_chart_version

  namespace        = "ingress"
  create_namespace = true
  values           = [file("values/nginx-internal-ingress.yaml")]

  depends_on = [helm_release.aws_lbc]
}
