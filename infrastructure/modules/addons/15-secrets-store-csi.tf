resource "helm_release" "secrets_csi_driver" {
  name = "secrets-store-csi-driver"

  repository = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
  chart      = "secrets-store-csi-driver"
  namespace  = "kube-system"
  version    = var.secrets_store_chart_version

  # set if you wan secre to be mounted as env variable
  set {
    name  = "syncSecret.enabled"
    value = true
  }

  depends_on = [helm_release.aws_lbc]
}


resource "helm_release" "secrets_csi_driver_aws_provider" {
  name = "secrets-store-csi-driver-provider-aws"

  repository = "https://aws.github.io/secrets-store-csi-driver-provider-aws"
  chart      = "secrets-store-csi-driver-provider-aws"
  namespace  = "kube-system"
  version    = var.secrets_store_aws_chart_version

  depends_on = [helm_release.secrets_csi_driver]
}

data "aws_iam_policy_document" "appliction_secrets" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringLike"
      variable = "${var.openid_connect_url}:sub"
      values   = ["system:serviceaccount:*:*"]
    }

    principals {
      identifiers = [var.openid_connect_arn]
      type        = "Federated"
    }

  }
}


resource "aws_iam_role" "application_secrets" {
  name               = "${var.cluster_name}-application-secrets"
  assume_role_policy = data.aws_iam_policy_document.appliction_secrets.json
  tags               = var.tags
}


resource "aws_iam_policy" "application_secrets" {
  name = "${var.cluster_name}-application-secrets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })

  tags = var.tags
}


resource "aws_iam_role_policy_attachment" "application_secrets" {
  policy_arn = aws_iam_policy.application_secrets.arn
  role       = aws_iam_role.application_secrets.name
}
