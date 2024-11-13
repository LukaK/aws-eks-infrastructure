output "application_secrets_role_arn" {
  value       = aws_iam_role.application_secrets.arn
  description = "Role arn to be used for retrieving secrets"
}
