<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.63 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 5.13.0 |

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.subdomain_nameservers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azs"></a> [azs](#input\_azs) | List of availability zones where networks is deployed | `list(string)` | n/a | yes |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | Vpc cidr block | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the eks cluster | `string` | n/a | yes |
| <a name="input_one_nat_gateway_per_az"></a> [one\_nat\_gateway\_per\_az](#input\_one\_nat\_gateway\_per\_az) | Deploy nat gateway for every availability zone | `bool` | `false` | no |
| <a name="input_primary_zone_id"></a> [primary\_zone\_id](#input\_primary\_zone\_id) | Primary zone id | `string` | n/a | yes |
| <a name="input_primary_zone_ns_record_type"></a> [primary\_zone\_ns\_record\_type](#input\_primary\_zone\_ns\_record\_type) | Primary zone record type for name servers | `string` | `"NS"` | no |
| <a name="input_primary_zone_record_name"></a> [primary\_zone\_record\_name](#input\_primary\_zone\_record\_name) | Record name for the primary zone | `string` | n/a | yes |
| <a name="input_primary_zone_record_ttl"></a> [primary\_zone\_record\_ttl](#input\_primary\_zone\_record\_ttl) | Time to live for the dns record | `number` | `172800` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | List of private subnet cidrs | `list(string)` | n/a | yes |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | List of public subnet cidrs | `list(string)` | n/a | yes |
| <a name="input_single_nat_gateway"></a> [single\_nat\_gateway](#input\_single\_nat\_gateway) | Deploy single nat gateway | `bool` | `true` | no |
| <a name="input_sub_domain_name"></a> [sub\_domain\_name](#input\_sub\_domain\_name) | Domain name | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Vpc name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_hosted_zone_id"></a> [hosted\_zone\_id](#output\_hosted\_zone\_id) | Hosted zone id |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | List of private subnet cidrs |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | Vpc id |
<!-- END_TF_DOCS -->