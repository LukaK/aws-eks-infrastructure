resource "helm_release" "internal_nginx" {
  name = "internal-nginx"

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = var.nginx_chart_version

  namespace        = "ingress"
  create_namespace = true

  values = [
    templatefile("values/nginx-internal-ingress.yaml", {
      election_id      = "internal-ingress-controller-leader"
      ingress_class    = local.internal_ingress_class_name
      controller_value = "k8s.io/internal-ingress-nginx"
    })
  ]

  depends_on = [helm_release.aws_lbc]
}
