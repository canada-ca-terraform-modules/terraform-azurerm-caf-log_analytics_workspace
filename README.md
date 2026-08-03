# Deploys Azure Monitor Log Analytics

Creates the Log Analytics Workspace, along with any Log Analytics Solutions
(`azurerm_log_analytics_solution`) and Windows Event data sources
(`azurerm_log_analytics_datasource_windows_event`) declared via
`solution_plan_map` and `datasource_windows_event_map`.

Requires the `azurerm` provider `~> 5.0`.

Reference the module to a specific version (recommended):
```hcl
module "log_analytics" {
  source            = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-log_analytics_workspace?ref=v1.1.0"
  userDefinedString = "${var.group}_${var.project}"
  resource_group    = azurerm_resource_group.Logs-rg
  tags              = var.tags
  env               = var.env

  solution_plan_map = {
    ServiceMap = {
      publisher = "Microsoft"
      product   = "OMSGallery/ServiceMap"
    },
    AzureActivity = {
      publisher = "Microsoft"
      product   = "OMSGallery/AzureActivity"
    },
    AgentHealthAssessment = {
      "publisher" = "Microsoft"
      "product"   = "OMSGallery/AgentHealthAssessment"
    },
    DnsAnalytics = {
      "publisher" = "Microsoft"
      "product"   = "OMSGallery/DnsAnalytics"
    },
    KeyVaultAnalytics = {
      "publisher" = "Microsoft"
      "product"   = "OMSGallery/KeyVaultAnalytics"
    },
  }
}
```

### ESLZ module block (`ESLZ/log_analytics_workspace.tf`)

See [`ESLZ/log_analytics_workspace.tf`](ESLZ/log_analytics_workspace.tf) and
[`ESLZ/log_analytics_workspace.tfvars`](ESLZ/log_analytics_workspace.tfvars) for the
map-based (`for_each`) L2 blueprint pattern.

## New optional arguments (azurerm >= 5.0)

| Key | Type | Description |
|---|---|---|
| `custom_name` | string | Override the auto-generated workspace name (default: `{env4}CLD-{userDefinedString}-{unique}-law`) |
| `local_authentication_enabled` | bool | Allow local authentication in addition to Microsoft Entra ID. Defaults to `true` (provider default) |
| `allow_resource_only_permissions` | bool | Allow resource-scoped access without workspace-level permission. Defaults to `true` (provider default) |
| `daily_quota_gb` | number | Daily ingestion quota in GB. Defaults to `-1` (unlimited, provider default) |
| `cmk_for_query_forced` | bool | Whether Customer Managed Storage is mandatory for query |
| `internet_ingestion_access_type` | string | `Enabled` \| `Disabled` \| `SecuredByPerimeter`. Defaults to `Enabled` |
| `internet_query_access_type` | string | `Enabled` \| `Disabled` \| `SecuredByPerimeter`. Defaults to `Enabled` |
| `reservation_capacity_in_gb_per_day` | number | Only used when `sku = "CapacityReservation"` |
| `data_collection_rule_id` | string | ID of the Data Collection Rule to use for this workspace |
| `immediate_data_purge_on_30_days_enabled` | bool | Remove data immediately after 30 days |
| `identity` | object | `{ type, identity_ids }` — `type` must be `SystemAssigned` or `UserAssigned`; `identity_ids` required and non-empty when `type = "UserAssigned"` |

See [`ESLZ/log_analytics_workspace.tfvars`](ESLZ/log_analytics_workspace.tfvars) for full commented examples.

> **Zero-trust callers:** `local_authentication_enabled` defaults to `null`, which lets the
> provider apply its own default (`true` — local authentication allowed alongside Microsoft
> Entra ID). Callers that want to require Entra ID-only authentication must explicitly set
> `local_authentication_enabled = false`.

## New outputs (azurerm >= 5.0)

| Name | Description |
|---|---|
| `workspace_id` | The Log Analytics Workspace GUID (customer ID) — used when registering agents (MMA, AMA), configuring Data Collection Rules, or cross-referencing solutions, without unwrapping the sensitive `object` output |

## Testing

```bash
terraform fmt -recursive && terraform init -backend=false && terraform validate && terraform test
```

## CI

GitHub Actions workflow at `.github/workflows/terraform-ci.yml` runs fmt, init, validate, test,
and tflint on every PR. `.github/workflows/release.yml` creates a GitHub release on merge to
main/master, tagged with the version pinned in `ESLZ/log_analytics_workspace.tf`'s own `?ref=`.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_log_analytics_datasource_windows_event.la_datasource_windows_event](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_datasource_windows_event) | resource |
| [azurerm_log_analytics_solution.la_solution](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_solution) | resource |
| [azurerm_log_analytics_workspace.log_analytics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_resource_only_permissions"></a> [allow\_resource\_only\_permissions](#input\_allow\_resource\_only\_permissions) | (Optional, azurerm >= 5.x) Specifies if users accessing data associated with resources they have permission to view are allowed to do so without permission to the workspace. Defaults to true (provider default) when omitted. | `bool` | `null` | no |
| <a name="input_cmk_for_query_forced"></a> [cmk\_for\_query\_forced](#input\_cmk\_for\_query\_forced) | (Optional, azurerm >= 5.x) Is Customer Managed Storage mandatory for query management? | `bool` | `null` | no |
| <a name="input_custom_name"></a> [custom\_name](#input\_custom\_name) | (Optional) Override the auto-generated Log Analytics Workspace name (default: {env4}CLD-{userDefinedString}-{unique}-law). | `string` | `null` | no |
| <a name="input_daily_quota_gb"></a> [daily\_quota\_gb](#input\_daily\_quota\_gb) | (Optional, azurerm >= 5.x) The workspace daily quota for ingestion in GB. Defaults to -1 (unlimited, provider default) when omitted. | `number` | `null` | no |
| <a name="input_data_collection_rule_id"></a> [data\_collection\_rule\_id](#input\_data\_collection\_rule\_id) | (Optional, azurerm >= 5.x) The ID of the Data Collection Rule to use for this workspace. | `string` | `null` | no |
| <a name="input_datasource_windows_event_map"></a> [datasource\_windows\_event\_map](#input\_datasource\_windows\_event\_map) | (Optional) Map structure containing the list of windows datasource events to be enabled. | `map(any)` | `{}` | no |
| <a name="input_env"></a> [env](#input\_env) | (Required) env value | `string` | `""` | no |
| <a name="input_identity"></a> [identity](#input\_identity) | (Optional, azurerm >= 5.x) An identity block object with a type key (SystemAssigned or UserAssigned) and an optional identity\_ids list, required when type is UserAssigned. | <pre>object({<br/>    type         = string<br/>    identity_ids = optional(list(string))<br/>  })</pre> | `null` | no |
| <a name="input_immediate_data_purge_on_30_days_enabled"></a> [immediate\_data\_purge\_on\_30\_days\_enabled](#input\_immediate\_data\_purge\_on\_30\_days\_enabled) | (Optional, azurerm >= 5.x) Whether to remove the data in the workspace immediately after 30 days. | `bool` | `null` | no |
| <a name="input_internet_ingestion_access_type"></a> [internet\_ingestion\_access\_type](#input\_internet\_ingestion\_access\_type) | (Optional, azurerm >= 5.x) Controls public network access for ingestion into the workspace. Possible values are Enabled, Disabled, and SecuredByPerimeter. Defaults to Enabled (provider default) when omitted. | `string` | `null` | no |
| <a name="input_internet_query_access_type"></a> [internet\_query\_access\_type](#input\_internet\_query\_access\_type) | (Optional, azurerm >= 5.x) Controls public network access for querying the workspace. Possible values are Enabled, Disabled, and SecuredByPerimeter. Defaults to Enabled (provider default) when omitted. | `string` | `null` | no |
| <a name="input_local_authentication_enabled"></a> [local\_authentication\_enabled](#input\_local\_authentication\_enabled) | (Optional, azurerm >= 5.x) Specifies if local authentication methods are allowed in addition to Microsoft Entra ID. Defaults to true (provider default) when omitted. | `bool` | `null` | no |
| <a name="input_reservation_capacity_in_gb_per_day"></a> [reservation\_capacity\_in\_gb\_per\_day](#input\_reservation\_capacity\_in\_gb\_per\_day) | (Optional, azurerm >= 5.x) The capacity reservation level in GB for this workspace. Only used when sku = CapacityReservation. | `number` | `null` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Required) Resource group object of where the LAW is to be created | `any` | n/a | yes |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | (Optional) The workspace data retention in days. Possible values are either 7 (Free Tier only) or range between 30 and 730. | `string` | `""` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | (Optional) sku name | `string` | `"PerGB2018"` | no |
| <a name="input_solution_plan_map"></a> [solution\_plan\_map](#input\_solution\_plan\_map) | (Optional) Map structure containing the list of solutions to be enabled. | `map(any)` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Required) tagging for the log analytics workspace | `map(string)` | n/a | yes |
| <a name="input_userDefinedString"></a> [userDefinedString](#input\_userDefinedString) | (Required) userDefinedString value | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | Output the object ID |
| <a name="output_name"></a> [name](#output\_name) | Output the object name |
| <a name="output_object"></a> [object](#output\_object) | Output the full object |
| <a name="output_workspace_id"></a> [workspace\_id](#output\_workspace\_id) | Output the Log Analytics Workspace GUID (customer ID, used when configuring agents and data sources) |
<!-- END_TF_DOCS -->

