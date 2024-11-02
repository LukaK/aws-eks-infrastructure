resource "aws_route53_zone" "this" {
  name          = var.sub_domain_name
  force_destroy = true
  tags          = var.tags
}
