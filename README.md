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
| `identity` | object | `{ type, identity_ids }` — `identity_ids` required when `type = "UserAssigned"` |

See [`ESLZ/log_analytics_workspace.tfvars`](ESLZ/log_analytics_workspace.tfvars) for full commented examples.

## Testing

```bash
terraform fmt -recursive && terraform init -backend=false && terraform validate && terraform test
```

## CI

GitHub Actions workflow at `.github/workflows/terraform-ci.yml` runs fmt, init, validate, test,
and tflint on every PR. `.github/workflows/release.yml` creates a GitHub release on merge to
main/master, tagged with the version pinned in `ESLZ/log_analytics_workspace.tf`'s own `?ref=`.

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

