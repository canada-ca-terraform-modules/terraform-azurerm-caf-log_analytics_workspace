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
