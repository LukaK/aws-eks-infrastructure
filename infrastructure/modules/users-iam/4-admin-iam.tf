resource "aws_iam_role" "eks_admin" {
  name = "${var.cluster_name}-eks-admin"

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

  tags = var.tags

}

resource "aws_iam_policy" "eks_admin" {
  name = "AmazonEKSAdminPolicy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "eks:*",
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

  tags = var.tags

}

# attach admin policy to the admin role
resource "aws_iam_role_policy_attachment" "eks_admin" {
  role       = aws_iam_role.eks_admin.name
  policy_arn = aws_iam_policy.eks_admin.arn
}

# bind the admin role to the rbac admin group
resource "aws_eks_access_entry" "eks_admin" {
  cluster_name      = var.cluster_name
  principal_arn     = aws_iam_role.eks_admin.arn
  kubernetes_groups = [var.admin_rbac_group_name]
}
