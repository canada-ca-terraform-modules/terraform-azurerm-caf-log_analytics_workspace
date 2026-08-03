variable "resource_group" {
  description = "(Required) Resource group object of where the LAW is to be created"
  type        = any
}

variable "env" {
  description = "(Required) env value"
  type        = string
  default     = ""
}

variable "userDefinedString" {
  description = "(Required) userDefinedString value"
  type        = string
  default     = ""
}

variable "sku" {
  description = "(Optional) sku name"
  type        = string
  default     = "PerGB2018"
}

variable "retention_in_days" {
  description = " (Optional) The workspace data retention in days. Possible values are either 7 (Free Tier only) or range between 30 and 730."
  type        = string
  default     = ""
}

variable "tags" {
  description = "(Required) tagging for the log analytics workspace"
  type        = map(string)
}

variable "solution_plan_map" {
  description = "(Optional) Map structure containing the list of solutions to be enabled."
  type        = map(any)
  default     = {}
}

variable "datasource_windows_event_map" {
  description = "(Optional) Map structure containing the list of windows datasource events to be enabled."
  type        = map(any)
  default     = {}
}

variable "custom_name" {
  description = "(Optional) Override the auto-generated Log Analytics Workspace name (default: {env4}CLD-{userDefinedString}-{unique}-law)."
  type        = string
  default     = null
}

variable "local_authentication_enabled" {
  description = "(Optional, azurerm >= 5.x) Specifies if local authentication methods are allowed in addition to Microsoft Entra ID. Defaults to true (provider default) when omitted."
  type        = bool
  default     = null
}

variable "allow_resource_only_permissions" {
  description = "(Optional, azurerm >= 5.x) Specifies if users accessing data associated with resources they have permission to view are allowed to do so without permission to the workspace. Defaults to true (provider default) when omitted."
  type        = bool
  default     = null
}

variable "daily_quota_gb" {
  description = "(Optional, azurerm >= 5.x) The workspace daily quota for ingestion in GB. Defaults to -1 (unlimited, provider default) when omitted."
  type        = number
  default     = null
}

variable "cmk_for_query_forced" {
  description = "(Optional, azurerm >= 5.x) Is Customer Managed Storage mandatory for query management?"
  type        = bool
  default     = null
}

variable "internet_ingestion_access_type" {
  description = "(Optional, azurerm >= 5.x) Controls public network access for ingestion into the workspace. Possible values are Enabled, Disabled, and SecuredByPerimeter. Defaults to Enabled (provider default) when omitted."
  type        = string
  default     = null

  validation {
    condition     = var.internet_ingestion_access_type == null || contains(["Enabled", "Disabled", "SecuredByPerimeter"], var.internet_ingestion_access_type)
    error_message = "internet_ingestion_access_type must be one of: Enabled, Disabled, SecuredByPerimeter."
  }
}

variable "internet_query_access_type" {
  description = "(Optional, azurerm >= 5.x) Controls public network access for querying the workspace. Possible values are Enabled, Disabled, and SecuredByPerimeter. Defaults to Enabled (provider default) when omitted."
  type        = string
  default     = null

  validation {
    condition     = var.internet_query_access_type == null || contains(["Enabled", "Disabled", "SecuredByPerimeter"], var.internet_query_access_type)
    error_message = "internet_query_access_type must be one of: Enabled, Disabled, SecuredByPerimeter."
  }
}

variable "reservation_capacity_in_gb_per_day" {
  description = "(Optional, azurerm >= 5.x) The capacity reservation level in GB for this workspace. Only used when sku = CapacityReservation."
  type        = number
  default     = null
}

variable "data_collection_rule_id" {
  description = "(Optional, azurerm >= 5.x) The ID of the Data Collection Rule to use for this workspace."
  type        = string
  default     = null
}

variable "immediate_data_purge_on_30_days_enabled" {
  description = "(Optional, azurerm >= 5.x) Whether to remove the data in the workspace immediately after 30 days."
  type        = bool
  default     = null
}

variable "identity" {
  description = "(Optional, azurerm >= 5.x) An identity block object with a type key (SystemAssigned or UserAssigned) and an optional identity_ids list, required when type is UserAssigned."
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  default = null

  validation {
    condition     = var.identity == null || contains(["SystemAssigned", "UserAssigned"], var.identity.type)
    error_message = "identity.type must be one of: SystemAssigned, UserAssigned."
  }

  validation {
    condition     = var.identity == null || var.identity.type != "UserAssigned" || (var.identity.identity_ids != null && length(var.identity.identity_ids) > 0)
    error_message = "identity.identity_ids must be provided and non-empty when identity.type is UserAssigned."
  }
}
