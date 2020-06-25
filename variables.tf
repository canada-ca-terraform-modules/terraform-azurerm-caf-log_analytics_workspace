variable "resource_group" {
  description = "(Required) Resource group object of where the LAW is to be created"
}

variable "env" {
  description = "(Required) 4 chars env name"
  type        = string
  default     = ""
}

variable "userDefinedString" {
  description = "(Required) userDefinedString value"
  type        = string
  default     = ""
}

variable "resource_group" {
  description = "(Required) Resource group object of where the LAW is to be created"
}

variable "sku" {
  description = "(Optional) sku name"
  default     = "PerGB2018"
}

variable "tags" {
  description = "(Required) tagging for the log analytics workspace"
}

variable "retention_in_days" {
  description = " (Optional) The workspace data retention in days. Possible values are either 7 (Free Tier only) or range between 30 and 730."
  type        = string
  default     = ""
}

