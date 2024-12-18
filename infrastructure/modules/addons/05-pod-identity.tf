resource "aws_eks_addon" "pod_identity" {
  cluster_name  = var.cluster_name
  addon_name    = "eks-pod-identity-agent"
  addon_version = var.pod_identity_version

  tags = var.tags
}
