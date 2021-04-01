# Deploys Azure Monitor Log Analytics   
Creates the log analytics and monitoring solutions.

Reference the module to a specific version (recommended):
```hcl
module "log_analytics" {
  source            = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-log_analytics_workspace?ref=v1.0.1"
  userDefinedString = "${var.group}_${var.project}"
  resource_group    = azurerm_resource_group.Logs-rg
  env               = var.env
  tags              = var.tags
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [azurerm_client_config](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) |
| [azurerm_log_analytics_datasource_windows_event](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_datasource_windows_event) |
| [azurerm_log_analytics_solution](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_solution) |
| [azurerm_log_analytics_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| resource\_group | (Required) Resource group object of where the LAW is to be created | `any` | n/a | yes |
| tags | (Required) tagging for the log analytics workspace | `map(string)` | n/a | yes |
| datasource\_windows\_event\_map | (Optional) Map structure containing the list of windows datasource events to be enabled. | `map(any)` | `{}` | no |
| env | (Required) env value | `string` | `""` | no |
| retention\_in\_days | (Optional) The workspace data retention in days. Possible values are either 7 (Free Tier only) or range between 30 and 730. | `string` | `""` | no |
| sku | (Optional) sku name | `string` | `"PerGB2018"` | no |
| solution\_plan\_map | (Optional) Map structure containing the list of solutions to be enabled. | `map(any)` | `{}` | no |
| userDefinedString | (Required) userDefinedString value | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | Output the object ID |
| name | Output the object name |
| object | Output the full object |
