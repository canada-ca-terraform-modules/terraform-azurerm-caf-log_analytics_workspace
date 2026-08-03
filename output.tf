output "id" {
  description = "Output the object ID"
  value       = azurerm_log_analytics_workspace.log_analytics.id
}

output "name" {
  description = "Output the object name"
  value       = azurerm_log_analytics_workspace.log_analytics.name
}

output "workspace_id" {
  description = "Output the Log Analytics Workspace GUID (customer ID, used when configuring agents and data sources)"
  value       = azurerm_log_analytics_workspace.log_analytics.workspace_id
}

output "object" {
  description = "Output the full object"
  value       = azurerm_log_analytics_workspace.log_analytics
  sensitive   = true
}
