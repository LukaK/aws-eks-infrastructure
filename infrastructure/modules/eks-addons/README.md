<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.63 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.32 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.63 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.32 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ebs_csi_driver_irsa"></a> [ebs\_csi\_driver\_irsa](#module\_ebs\_csi\_driver\_irsa) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | 5.44.0 |
| <a name="module_eks_addons"></a> [eks\_addons](#module\_eks\_addons) | aws-ia/eks-blueprints-addons/aws | 1.16.3 |

## Resources

| Name | Type |
|------|------|
| [aws_efs_file_system.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system) | resource |
| [aws_efs_mount_target.zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |
| [kubernetes_storage_class_v1.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/storage_class_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_efs_csi_driver_chart_version"></a> [aws\_efs\_csi\_driver\_chart\_version](#input\_aws\_efs\_csi\_driver\_chart\_version) | Helm chart version for efs csi driver | `string` | `"2.5.6"` | no |
| <a name="input_aws_load_balancer_controller_chart_version"></a> [aws\_load\_balancer\_controller\_chart\_version](#input\_aws\_load\_balancer\_controller\_chart\_version) | Helm chart version for load balancer controller | `string` | `"1.7.1"` | no |
| <a name="input_cluster_autoscaler_chart_version"></a> [cluster\_autoscaler\_chart\_version](#input\_cluster\_autoscaler\_chart\_version) | Helm chart version for cluster\_autoscaler | `string` | `"9.35.0"` | no |
| <a name="input_cluster_endpoint"></a> [cluster\_endpoint](#input\_cluster\_endpoint) | Eks cluster endpoint | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Eks cluster name | `string` | n/a | yes |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | Eks cluster version | `string` | n/a | yes |
| <a name="input_efs_storage_configuration"></a> [efs\_storage\_configuration](#input\_efs\_storage\_configuration) | Efs storage configuration | <pre>object({<br>    subnet_ids                          = list(string)<br>    security_group_ids                  = list(string)<br>    storage_class_name                  = string<br>    storage_class_directory_permissions = string<br>  })</pre> | n/a | yes |
| <a name="input_enable_aws_efs_csi_driver"></a> [enable\_aws\_efs\_csi\_driver](#input\_enable\_aws\_efs\_csi\_driver) | Flag to enable efs csi controller | `bool` | `false` | no |
| <a name="input_enable_aws_load_balancer_controller"></a> [enable\_aws\_load\_balancer\_controller](#input\_enable\_aws\_load\_balancer\_controller) | Flag to enable load balancer controller | `bool` | `false` | no |
| <a name="input_enable_cluster_autoscaler"></a> [enable\_cluster\_autoscaler](#input\_enable\_cluster\_autoscaler) | Flag to enable cluster autoscaler | `bool` | `false` | no |
| <a name="input_enable_metrics_server"></a> [enable\_metrics\_server](#input\_enable\_metrics\_server) | Flag to enable metric server | `bool` | `false` | no |
| <a name="input_metric_server_chart_version"></a> [metric\_server\_chart\_version](#input\_metric\_server\_chart\_version) | Helm chart version for metric server | `string` | `"3.12.0"` | no |
| <a name="input_oidc_provider_arn"></a> [oidc\_provider\_arn](#input\_oidc\_provider\_arn) | Eks cluster OpenID connect provider arn | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->