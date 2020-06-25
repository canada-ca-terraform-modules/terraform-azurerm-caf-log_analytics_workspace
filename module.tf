locals {
  module_tag  = {
    "module" = basename(abspath(path.module))
  }
  tags = merge(var.tags,local.module_tag)
  unique                          = substr(sha1(var.resource_group.id), 0, 8)
  log_analytics_workspace-replace = replace("${var.env}CLD-${var.userDefinedString}", "_", "-")
  log_analytics_workspace-regex   = regex("[0-9A-Za-z-]+", local.log_analytics_workspace-replace)
  log_analytics_workspace-54      = substr(local.log_analytics_workspace-regex, 0, 54)
  log_analytics_workspace-59      = substr("${local.log_analytics_workspace-54}-${local.unique}", 0, 59)
  log_analytics_workspace-result  = "${local.log_analytics_workspace-59}-law"
}

//Can't have a "_" in the name, only "-"
resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = local.log_analytics_workspace-result
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  sku                 = var.sku
  tags                = local.tags
  retention_in_days   = var.retention_in_days != "" ? var.retention_in_days : null
}