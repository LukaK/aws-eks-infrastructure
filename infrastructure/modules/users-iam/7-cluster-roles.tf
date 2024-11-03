resource "helm_release" "cluster_roles" {
  name      = "cluster-roles"
  chart     = "./charts/default-cluster-roles/"
  namespace = "kube-system"
}
