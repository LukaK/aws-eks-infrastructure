<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.63 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.16.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eks_addon.ebs_csi_driver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon.pod_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_pod_identity_association.aws_lbc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_pod_identity_association) | resource |
| [aws_eks_pod_identity_association.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_pod_identity_association) | resource |
| [aws_eks_pod_identity_association.ebs_csi_driver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_pod_identity_association) | resource |
| [aws_eks_pod_identity_association.efs_csi_driver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_pod_identity_association) | resource |
| [aws_iam_policy.aws_lbc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.ebs_csi_driver_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.aws_lbc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.ebs_csi_driver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.efs_csi_driver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.aws_lbc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ebs_csi_driver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ebs_csi_driver_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.efs_csi_driver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [helm_release.argocd](https://registry.terraform.io/providers/hashicorp/helm/2.16.0/docs/resources/release) | resource |
| [helm_release.aws_lbc](https://registry.terraform.io/providers/hashicorp/helm/2.16.0/docs/resources/release) | resource |
| [helm_release.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/helm/2.16.0/docs/resources/release) | resource |
| [helm_release.efs_csi_driver](https://registry.terraform.io/providers/hashicorp/helm/2.16.0/docs/resources/release) | resource |
| [helm_release.external_nginx](https://registry.terraform.io/providers/hashicorp/helm/2.16.0/docs/resources/release) | resource |
| [helm_release.metric_server](https://registry.terraform.io/providers/hashicorp/helm/2.16.0/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_argocd_chart_version"></a> [argocd\_chart\_version](#input\_argocd\_chart\_version) | Helm chart version for argocd | `string` | `"7.6.12"` | no |
| <a name="input_aws_lbc_chart_version"></a> [aws\_lbc\_chart\_version](#input\_aws\_lbc\_chart\_version) | Helm chart version for aws load balancer controller | `string` | `"1.9.1"` | no |
| <a name="input_cluster_autoscaler_chart_version"></a> [cluster\_autoscaler\_chart\_version](#input\_cluster\_autoscaler\_chart\_version) | Helm chart version for cluster autoscaler | `string` | `"9.37.0"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Eks cluster name | `string` | n/a | yes |
| <a name="input_ebs_csi_driver_version"></a> [ebs\_csi\_driver\_version](#input\_ebs\_csi\_driver\_version) | Version of the ebs csi driver. | `string` | `"v1.35.0-eksbuild.1"` | no |
| <a name="input_efs_csi_chart_version"></a> [efs\_csi\_chart\_version](#input\_efs\_csi\_chart\_version) | Helm chart version for efs csi driver | `string` | `"3.0.8"` | no |
| <a name="input_metric_server_chart_version"></a> [metric\_server\_chart\_version](#input\_metric\_server\_chart\_version) | Helm chart version for metric server | `string` | `"3.12.1"` | no |
| <a name="input_nginx_chart_version"></a> [nginx\_chart\_version](#input\_nginx\_chart\_version) | Helm chart version for nginx | `string` | `"4.10.1"` | no |
| <a name="input_pod_identity_version"></a> [pod\_identity\_version](#input\_pod\_identity\_version) | Version of the pod identity agent | `string` | `"v1.3.2-eksbuild.2"` | no |
| <a name="input_region"></a> [region](#input\_region) | Aws region | `string` | `"eu-west-1"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->