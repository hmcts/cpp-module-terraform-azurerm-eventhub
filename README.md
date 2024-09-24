# terraform-module-template

<!-- TODO fill in resource name in link to product documentation -->
Terraform module for [Resource name](https://example.com).

## Example

<!-- todo update module name
```hcl
module "todo_resource_name" {
  source = "git@github.com:hmcts/terraform-module-postgresql-flexible?ref=master"
  ...
}

```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.2.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.3.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_eventhub.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub) | resource |
| [azurerm_eventhub_namespace.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Application to which the s3 bucket relates | `string` | `""` | no |
| <a name="input_attribute"></a> [attribute](#input\_attribute) | An attribute of the s3 bucket that makes it unique | `string` | `""` | no |
| <a name="input_auto_inflate_enabled"></a> [auto\_inflate\_enabled](#input\_auto\_inflate\_enabled) | (Optional) Is Auto Inflate enabled for the EventHub Namespace? | `bool` | `false` | no |
| <a name="input_capacity"></a> [capacity](#input\_capacity) | (Optional) Specifies the Capacity / Throughput Units for a Standard SKU namespace. Valid values range from 1 - 20. | `string` | `"1"` | no |
| <a name="input_costcode"></a> [costcode](#input\_costcode) | Name of theDWP PRJ number (obtained from the project portfolio in TechNow) | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment into which resource is deployed | `string` | `""` | no |
| <a name="input_eventhub_name"></a> [eventhub\_name](#input\_eventhub\_name) | (Required) Specifies the name of the EventHub resource. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_eventhub_namespace_name"></a> [eventhub\_namespace\_name](#input\_eventhub\_namespace\_name) | (Required) Specifies the name of the Eventhub namespace. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | `"uksouth"` | no |
| <a name="input_maximum_throughput_units"></a> [maximum\_throughput\_units](#input\_maximum\_throughput\_units) | (Optional) Specifies the maximum number of throughput units when Auto Inflate is Enabled. Valid values range from 1 - 20. | `number` | `null` | no |
| <a name="input_message_retention"></a> [message\_retention](#input\_message\_retention) | (Required) Specifies the number of days to retain the events for this Event Hub. | `number` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace, which could be an organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `""` | no |
| <a name="input_network_rulesets"></a> [network\_rulesets](#input\_network\_rulesets) | A map of network\_rulesets blocks as defined below.<br>{<br>  [ruleset\_name] = {<br>    default\_action = ["Allow" \|\| "Deny"]<br>    ip\_rule = [ # (Optional)<br>      {<br>        ip\_mask = "x.x.x.x/xx"<br>        action  = ["Allow" \|\| "Deny"]<br>      }<br>    virtual\_network\_rule = [<br>      {<br>        subnet\_id                                       = [subnet\_id]<br>        ignore\_missing\_virtual\_network\_service\_endpoint = [true \|\| false]<br>      }<br>    ]<br>  }<br>} | <pre>map(object({<br>    default_action = string<br>    ip_rule = map(object({<br>      ip_mask = string<br>      action  = string<br>    }))<br>    virtual_network_rule = map(object({<br>      subnet_id                                       = string<br>      ignore_missing_virtual_network_service_endpoint = bool<br>    }))<br>  }))</pre> | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | Name of the project or sqaud within the PDU which manages the resource. May be a persons name or email also | `string` | `""` | no |
| <a name="input_partition_count"></a> [partition\_count](#input\_partition\_count) | (Required) Specifies the current number of shards on the Event Hub. Changing this forces a new resource to be created. | `number` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create the event hub. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_sku"></a> [sku](#input\_sku) | (Required) Defines which tier to use. Valid options are Basic and Standard. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_type"></a> [type](#input\_type) | Name of service type | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eventhub_name"></a> [eventhub\_name](#output\_eventhub\_name) | n/a |
| <a name="output_eventhub_namespace_name"></a> [eventhub\_namespace\_name](#output\_eventhub\_namespace\_name) | n/a |
<!-- END_TF_DOCS -->

## Contributing

We use pre-commit hooks for validating the terraform format and maintaining the documentation automatically.
Install it with:

```shell
$ brew install pre-commit terraform-docs
$ pre-commit install
```

If you add a new hook make sure to run it against all files:
```shell
$ pre-commit run --all-files
```
