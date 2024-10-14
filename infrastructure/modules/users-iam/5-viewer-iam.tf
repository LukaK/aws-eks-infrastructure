resource "aws_iam_role" "eks_viewer" {
  name = "${var.cluster_name}-eks-viewer"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.this.account_id}:root"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "eks_viewer" {
  name = "AmazonEKSViewerPolicy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "iam:PassRole"
        ]
        Effect   = "Allow"
        Resource = "*",
        Condition = {
          "StringEquals" = {
            "iam:PassedToService" = "eks.amazonaws.com"
          }
        }
      },
    ]
  })
}

# attach viewer policy to the viewer role
resource "aws_iam_role_policy_attachment" "eks_viewer" {
  role       = aws_iam_role.eks_viewer.name
  policy_arn = aws_iam_policy.eks_viewer.arn
}


# bind the role to the eks cluster role
resource "aws_eks_access_entry" "eks_viewer" {
  cluster_name      = var.cluster_name
  principal_arn     = aws_iam_role.eks_viewer.arn
  kubernetes_groups = [var.viewer_rbac_group_name]
}
