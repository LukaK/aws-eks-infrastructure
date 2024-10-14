output "admin_role_arn" {
  value       = aws_iam_role.eks_admin.arn
  description = "Arn of the admin role"
}

output "viewer_role_arn" {
  value       = aws_iam_role.eks_viewer.arn
  description = "Arn of the viewer role"
}
