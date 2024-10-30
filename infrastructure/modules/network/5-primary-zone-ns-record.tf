resource "aws_route53_record" "subdomain_nameservers" {
  provider = aws.network

  zone_id = var.primary_zone_id
  name    = var.primary_zone_record_name
  records = aws_route53_zone.this.name_servers

  type = var.primary_zone_ns_record_type
  ttl  = var.primary_zone_record_ttl
}
