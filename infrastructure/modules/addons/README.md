<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.16.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.16.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.metric_server](https://registry.terraform.io/providers/hashicorp/helm/2.16.0/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Eks cluster name | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->