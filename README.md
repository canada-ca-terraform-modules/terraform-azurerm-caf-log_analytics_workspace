# Deploys Azure Monitor Log Analytics 
Creates the log analytics and monitoring solutions. 

Reference the module to a specific version (recommended):
```hcl
module "log_analytics" {
    source  = "aztfmod/caf-log-analytics/azurerm"
    version = "0.x.y"

    name                              = var.name
    solution_plan_map                 = var.solutions
    resource_group_name               = var.rg
    prefix                            = var.prefix
    location                          = var.location
    tags                              = var.tags
    
}
```

## Inputs 

| Name              | Type   | Default | Description                                                                                                                 |
| ----------------- | ------ | ------- | --------------------------------------------------------------------------------------------------------------------------- |
| resource_group    | object | None    | (Required) The resource group object where to create the resource. Changing this forces a new resource to be created.       | ) |
| tags              | map    | None    | (Required) Map of tags for the deployment.                                                                                  |
| retention_in_days | number | None    | (Optional) The workspace data retention in days. Possible values are either 7 (Free Tier only) or range between 30 and 730. |
| sku               | string | None    | (Optional) Default: PerGB2018                                                                                               |
| userDefinedString | string | None    | (Required) userDefinedString to be Used.                                                                                    |

