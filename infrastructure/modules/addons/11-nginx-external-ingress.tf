resource "helm_release" "external_nginx" {
  name = "external-nginx"

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = var.nginx_chart_version

  namespace        = "ingress"
  create_namespace = true

  values = [
    templatefile("values/nginx-external-ingress.yaml", {
      election_id      = "external-ingress-controller-leader"
      ingress_class    = local.external_ingress_class_name
      controller_value = "k8s.io/external-ingress-nginx"
    })
  ]

  depends_on = [helm_release.aws_lbc]
}
