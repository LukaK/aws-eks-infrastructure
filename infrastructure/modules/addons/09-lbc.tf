resource "aws_iam_role" "aws_lbc" {
  name = "${var.cluster_name}-aws-lbc"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Principal = {
          Service = "pods.eks.amazonaws.com"
        }
      },
    ]
  })

  tags = var.tags
}

resource "aws_iam_policy" "aws_lbc" {
  policy = file("./iam/lbc-policy.json")
  name   = "AWSLoadBalancerController"

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "aws_lbc" {
  policy_arn = aws_iam_policy.aws_lbc.arn
  role       = aws_iam_role.aws_lbc.name
}


resource "aws_eks_pod_identity_association" "aws_lbc" {
  cluster_name    = var.cluster_name
  namespace       = "kube-system"
  service_account = "aws-load-balancer-controller"
  role_arn        = aws_iam_role.aws_lbc.arn
}

resource "helm_release" "aws_lbc" {
  name = "aws-load-balancer-controller"

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = var.aws_lbc_chart_version


  values = [
    templatefile("values/lbc.yaml", {
      service_account_name = "aws-load-balancer-controller"
      cluster_name         = var.cluster_name
    })
  ]

  depends_on = [helm_release.efs_csi_driver, aws_iam_role_policy_attachment.aws_lbc]
}
