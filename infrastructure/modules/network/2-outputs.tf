output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "Vpc id"
}

output "private_subnets" {
  value       = module.vpc.private_subnets
  description = "List of private subnet cidrs"
}

output "hosted_zone_id" {
  value       = aws_route53_zone.this.zone_id
  description = "Hosted zone id"
}

output "hosted_zone_name" {
  value       = var.sub_domain_name
  description = "Name of the hosted zone"
}
