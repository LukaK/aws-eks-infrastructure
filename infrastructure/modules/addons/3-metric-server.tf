resource "helm_release" "metric_server" {
  name = "metrics-server"

  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = "kube-system"
  version    = var.metric_server_chart_version

  values = [file("${path.module}/values/metrics-server.yaml")]
}
