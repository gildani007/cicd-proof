<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.6.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_helm_release"></a> [helm\_release](#module\_helm\_release) | ../../components/helm_release | n/a |

## Resources

| Name | Type |
|------|------|
| [kubernetes_namespace.web-application-namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chart"></a> [chart](#input\_chart) | The Helm chart path | `string` | `"unset"` | no |
| <a name="input_environment_name"></a> [environment\_name](#input\_environment\_name) | The target environment for the application | `string` | `"unset"` | no |
| <a name="input_helm_values"></a> [helm\_values](#input\_helm\_values) | Helm values as a map | `any` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace for the Helm release | `string` | `"unset"` | no |
| <a name="input_release_name"></a> [release\_name](#input\_release\_name) | The Helm release name | `string` | `"unset"` | no |
| <a name="input_values"></a> [values](#input\_values) | n/a | `map(any)` | <pre>{<br/>  "key1": "default_value1",<br/>  "key2": "default_value2"<br/>}</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->