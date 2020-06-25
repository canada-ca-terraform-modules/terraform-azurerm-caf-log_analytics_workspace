variable "resource_group" {
  description = "(Required) Resource group object of where the LAW is to be created"
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