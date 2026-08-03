locals {
  module_tag = {
    "module" = basename(abspath(path.module))
  }
  tags                                    = merge(var.tags, local.module_tag)
  unique                                  = substr(sha1(var.resource_group.id), 0, 8)
  env_4                                   = substr(var.env, 0, 4)
  log_analytics_workspace-no_underscore   = replace("${local.env_4}CLD-${var.userDefinedString}", "_", "-")
  log_analytics_workspace-regex           = "/[^0-9A-Za-z-]/" # Anti-pattern to match all characters not in: 0-9 a-z A-Z -
  log_analytics_workspace-regex_compliant = replace(local.log_analytics_workspace-no_underscore, local.log_analytics_workspace-regex, "")
  log_analytics_workspace-54              = substr(local.log_analytics_workspace-regex_compliant, 0, 54)
  log_analytics_workspace-59              = substr("${local.log_analytics_workspace-54}-${local.unique}", 0, 59)
  log_analytics_workspace-result          = "${local.log_analytics_workspace-59}-law"
}

resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = var.custom_name != null ? var.custom_name : local.log_analytics_workspace-result
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  sku                 = var.sku
  tags                = local.tags
  retention_in_days   = var.retention_in_days != "" ? var.retention_in_days : null

  # New in azurerm >= 5.x — all optional and gated with try(), so existing callers
  # that don't set these keep the provider's own defaults with no plan diff.
  local_authentication_enabled            = try(var.local_authentication_enabled, null)
  allow_resource_only_permissions         = try(var.allow_resource_only_permissions, null)
  daily_quota_gb                          = try(var.daily_quota_gb, null)
  cmk_for_query_forced                    = try(var.cmk_for_query_forced, null)
  internet_ingestion_access_type          = try(var.internet_ingestion_access_type, null)
  internet_query_access_type              = try(var.internet_query_access_type, null)
  reservation_capacity_in_gb_per_day      = try(var.reservation_capacity_in_gb_per_day, null)
  data_collection_rule_id                 = try(var.data_collection_rule_id, null)
  immediate_data_purge_on_30_days_enabled = try(var.immediate_data_purge_on_30_days_enabled, null)

  dynamic "identity" {
    for_each = try(var.identity, null) != null ? [var.identity] : []

    content {
      type         = identity.value.type
      identity_ids = try(identity.value.identity_ids, null)
    }
  }
}

resource "azurerm_log_analytics_solution" "la_solution" {
  for_each = var.solution_plan_map

  solution_name         = each.key
  location              = var.resource_group.location
  resource_group_name   = var.resource_group.name
  workspace_resource_id = azurerm_log_analytics_workspace.log_analytics.id
  workspace_name        = azurerm_log_analytics_workspace.log_analytics.name

  plan {
    product   = each.value.product
    publisher = each.value.publisher
  }

  tags = var.tags
}

resource "azurerm_log_analytics_datasource_windows_event" "la_datasource_windows_event" {
  for_each = var.datasource_windows_event_map

  name                = each.key
  resource_group_name = var.resource_group.name
  workspace_name      = azurerm_log_analytics_workspace.log_analytics.name
  event_log_name      = each.value.event_log_name
  event_types         = each.value.event_types
}
