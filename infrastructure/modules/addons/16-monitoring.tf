resource "helm_release" "prometheus-grafana" {
  name = "prometheus-grafana"

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = "monitoring"
  create_namespace = true
  version    = var.prometheus_chart_version

  values = [
    templatefile("values/prometheus-grafana.yaml", {
      hosted_zone_name    = var.hosted_zone_name
      ingress_class_name  = local.external_ingress_class_name
      cluster_issuer_name = local.cluster_issuer_name
    })
  ]
}
