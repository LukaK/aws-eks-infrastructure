resource "aws_iam_role" "cert_manager" {
  name = "${var.cluster_name}-cert-manager"

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

resource "aws_iam_policy" "cert_manager" {
  name = "${var.cluster_name}-cert-manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "route53:GetChange"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:route53:::change/*"
      },
      {
        Action = [
          "route53:ChangeResourceRecordSets",
          "route53:ListResourceRecordSets"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:route53:::hostedzone/*"
      },
      {
        Action = [
          "route53:ListHostedZonesByName",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "cert_manager" {
  policy_arn = aws_iam_policy.cert_manager.arn
  role       = aws_iam_role.cert_manager.name
}


resource "aws_eks_pod_identity_association" "cert_manager" {
  cluster_name    = var.cluster_name
  namespace       = "cert-manager"
  service_account = "cert-manager-sa"
  role_arn        = aws_iam_role.cert_manager.arn
}



resource "helm_release" "cert-manager" {
  name = "cert-manager"

  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true
  version          = var.cert_manager_chart_version

  values = [
    templatefile("values/cert-manager.yaml", {
      service_account_name = "cert-manager-sa"
    })
  ]

  depends_on = [helm_release.external_nginx, helm_release.external_dns]
}



resource "helm_release" "cluster_issuers" {
  name             = "cluster-issuers"
  chart            = "./charts/cert-manager-cluster-issuer"
  namespace        = "cert-manager"
  create_namespace = true


  values = [
    templatefile("values/cert-manager-cluster-issuer.yaml", {
      aws_region          = var.region
      email               = var.cert_manager_notification_email
      dns_zone            = var.hosted_zone_name
      hosted_zone_id      = var.hosted_zone_id
      cluster_issuer_name = local.cluster_issuer_name
    })
  ]

  depends_on = [helm_release.cert-manager]
}
