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

## Inputs 

| Name              | Type   | Default | Description                                                                                                                 |
| ----------------- | ------ | ------- | --------------------------------------------------------------------------------------------------------------------------- |
| resource_group    | object | None    | (Required) The resource group object where to create the resource. Changing this forces a new resource to be created.       | ) |
| tags              | map    | None    | (Required) Map of tags for the deployment.                                                                                  |
| retention_in_days | number | None    | (Optional) The workspace data retention in days. Possible values are either 7 (Free Tier only) or range between 30 and 730. |
| sku               | string | None    | (Optional) Default: PerGB2018                                                                                               |
| env               | string | None    | {Required} env name                                                                                                         |
| userDefinedString | string | None    | (Required) userDefinedString to be Used.                                                                                    |

