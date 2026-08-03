terraform {
  required_version = ">= 1.9"
}

variable "log_analytics_workspaces" {
  type        = any
  default     = {}
  description = "Map of log_analytics_workspace objects. Key is used as userDefinedString. See log_analytics_workspace.tfvars for shape."
}

variable "resource_groups" {
  description = "Map of resource group objects, keyed by name, used to resolve each instance's `resource_group` key."
  type        = any
  default     = {}
}

module "log_analytics_workspace" {
  for_each = var.log_analytics_workspaces
  source   = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-log_analytics_workspace?ref=v1.1.0"

  env                                     = var.env
  userDefinedString                       = each.key
  resource_group                          = var.resource_groups[each.value.resource_group]
  tags                                    = var.tags
  sku                                     = try(each.value.sku, "PerGB2018")
  retention_in_days                       = try(each.value.retention_in_days, "")
  solution_plan_map                       = try(each.value.solution_plan_map, {})
  datasource_windows_event_map            = try(each.value.datasource_windows_event_map, {})
  custom_name                             = try(each.value.custom_name, null)
  local_authentication_enabled            = try(each.value.local_authentication_enabled, null)
  allow_resource_only_permissions         = try(each.value.allow_resource_only_permissions, null)
  daily_quota_gb                          = try(each.value.daily_quota_gb, null)
  cmk_for_query_forced                    = try(each.value.cmk_for_query_forced, null)
  internet_ingestion_access_type          = try(each.value.internet_ingestion_access_type, null)
  internet_query_access_type              = try(each.value.internet_query_access_type, null)
  reservation_capacity_in_gb_per_day      = try(each.value.reservation_capacity_in_gb_per_day, null)
  data_collection_rule_id                 = try(each.value.data_collection_rule_id, null)
  immediate_data_purge_on_30_days_enabled = try(each.value.immediate_data_purge_on_30_days_enabled, null)
  identity                                = try(each.value.identity, null)
}
