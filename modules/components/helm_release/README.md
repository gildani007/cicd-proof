<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.6.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 2.17.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.helm_resource](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chart"></a> [chart](#input\_chart) | The Helm chart path | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace for the Helm release | `string` | n/a | yes |
| <a name="input_release_name"></a> [release\_name](#input\_release\_name) | The Helm release name | `string` | n/a | yes |
| <a name="input_values"></a> [values](#input\_values) | Helm values as a map | `any` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->