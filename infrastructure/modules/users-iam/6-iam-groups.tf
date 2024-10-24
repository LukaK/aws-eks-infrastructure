# create iam group for the cluster admins
resource "aws_iam_group" "eks_admins" {
  name = "${var.cluster_name}-admins"
}

# create policy to assume eks admin role
resource "aws_iam_policy" "eks_admin_group" {
  name = "AmazonEKSAssumeAdminPolicy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole"
        ]
        Effect   = "Allow"
        Resource = aws_iam_role.eks_admin.arn
      },
    ]
  })
  tags = var.tags
}

# attach the policy to the eks admins group
resource "aws_iam_group_policy_attachment" "eks_admin_group" {
  group      = aws_iam_group.eks_admins.name
  policy_arn = aws_iam_policy.eks_admin_group.arn
}


# create iam group for the cluster viewers
resource "aws_iam_group" "eks_viewers" {
  name = "${var.cluster_name}-viewers"
}

# create policy to assume eks viewer role
resource "aws_iam_policy" "eks_viewer_group" {
  name = "AmazonEKSAssumeViewerPolicy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole"
        ]
        Effect   = "Allow"
        Resource = aws_iam_role.eks_viewer.arn
      },
    ]
  })
  tags = var.tags
}

# attach the policy to the eks viewers group
resource "aws_iam_group_policy_attachment" "eks_viewer_group" {
  group      = aws_iam_group.eks_viewers.name
  policy_arn = aws_iam_policy.eks_viewer_group.arn
}
