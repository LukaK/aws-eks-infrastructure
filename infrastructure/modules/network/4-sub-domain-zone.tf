resource "aws_route53_zone" "this" {
  name = var.sub_domain_name
  tags = var.tags
}
