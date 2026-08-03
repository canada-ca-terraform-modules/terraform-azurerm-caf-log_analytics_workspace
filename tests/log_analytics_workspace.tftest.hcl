mock_provider "azurerm" {}

variables {
  env               = "Dev"
  userDefinedString = "app"
  resource_group = {
    id       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test"
    name     = "rg-test"
    location = "canadacentral"
  }
  tags = {
    environment = "test"
  }
}

run "naming_convention" {
  command = plan

  assert {
    condition     = azurerm_log_analytics_workspace.log_analytics.name == "DevCLD-app-3b37d93d-law"
    error_message = "Name must follow {env4}CLD-{userDefinedString}-{unique}-law convention"
  }
}

run "naming_convention_custom_name" {
  command = plan

  variables {
    custom_name = "my-existing-law"
  }

  assert {
    condition     = azurerm_log_analytics_workspace.log_analytics.name == "my-existing-law"
    error_message = "custom_name must override the generated name"
  }
}

run "default_values" {
  command = plan

  assert {
    condition     = azurerm_log_analytics_workspace.log_analytics.sku == "PerGB2018"
    error_message = "sku must default to PerGB2018"
  }

  assert {
    condition     = azurerm_log_analytics_workspace.log_analytics.local_authentication_enabled == null
    error_message = "local_authentication_enabled must be null (unset) when omitted, letting the provider default apply"
  }

  assert {
    condition     = length(azurerm_log_analytics_workspace.log_analytics.identity) == 0
    error_message = "identity block must not be emitted when omitted"
  }
}

run "retention_in_days_set" {
  command = plan

  variables {
    retention_in_days = 30
  }

  assert {
    condition     = azurerm_log_analytics_workspace.log_analytics.retention_in_days == 30
    error_message = "retention_in_days must be set when provided"
  }
}

run "new_optional_arguments" {
  command = plan

  variables {
    local_authentication_enabled            = false
    allow_resource_only_permissions         = false
    daily_quota_gb                          = 5
    cmk_for_query_forced                    = true
    internet_ingestion_access_type          = "Disabled"
    internet_query_access_type              = "Disabled"
    data_collection_rule_id                 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Insights/dataCollectionRules/example"
    immediate_data_purge_on_30_days_enabled = true
  }

  assert {
    condition     = azurerm_log_analytics_workspace.log_analytics.local_authentication_enabled == false
    error_message = "local_authentication_enabled must be settable"
  }

  assert {
    condition     = azurerm_log_analytics_workspace.log_analytics.allow_resource_only_permissions == false
    error_message = "allow_resource_only_permissions must be settable"
  }

  assert {
    condition     = azurerm_log_analytics_workspace.log_analytics.daily_quota_gb == 5
    error_message = "daily_quota_gb must be settable"
  }

  assert {
    condition     = azurerm_log_analytics_workspace.log_analytics.cmk_for_query_forced == true
    error_message = "cmk_for_query_forced must be settable"
  }

  assert {
    condition     = azurerm_log_analytics_workspace.log_analytics.internet_ingestion_access_type == "Disabled"
    error_message = "internet_ingestion_access_type must be settable"
  }

  assert {
    condition     = azurerm_log_analytics_workspace.log_analytics.internet_query_access_type == "Disabled"
    error_message = "internet_query_access_type must be settable"
  }

  assert {
    condition     = azurerm_log_analytics_workspace.log_analytics.data_collection_rule_id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Insights/dataCollectionRules/example"
    error_message = "data_collection_rule_id must be settable"
  }

  assert {
    condition     = azurerm_log_analytics_workspace.log_analytics.immediate_data_purge_on_30_days_enabled == true
    error_message = "immediate_data_purge_on_30_days_enabled must be settable"
  }
}

run "reservation_capacity" {
  command = plan

  variables {
    sku                                = "CapacityReservation"
    reservation_capacity_in_gb_per_day = 100
  }

  assert {
    condition     = azurerm_log_analytics_workspace.log_analytics.sku == "CapacityReservation"
    error_message = "sku must be settable to CapacityReservation"
  }

  assert {
    condition     = azurerm_log_analytics_workspace.log_analytics.reservation_capacity_in_gb_per_day == 100
    error_message = "reservation_capacity_in_gb_per_day must be settable when sku = CapacityReservation"
  }
}

run "system_assigned_identity" {
  command = plan

  variables {
    identity = {
      type = "SystemAssigned"
    }
  }

  assert {
    condition     = length(azurerm_log_analytics_workspace.log_analytics.identity) == 1
    error_message = "identity block must be emitted when identity is configured"
  }

  assert {
    condition     = azurerm_log_analytics_workspace.log_analytics.identity[0].type == "SystemAssigned"
    error_message = "identity.type must be passed through"
  }
}

run "solution_plan_map" {
  command = plan

  variables {
    solution_plan_map = {
      AzureActivity = {
        publisher = "Microsoft"
        product   = "OMSGallery/AzureActivity"
      }
    }
  }

  assert {
    condition     = azurerm_log_analytics_solution.la_solution["AzureActivity"].solution_name == "AzureActivity"
    error_message = "solution_name must equal the solution_plan_map key"
  }

  assert {
    condition     = azurerm_log_analytics_solution.la_solution["AzureActivity"].plan[0].product == "OMSGallery/AzureActivity"
    error_message = "plan.product must be passed through"
  }
}

run "datasource_windows_event_map" {
  command = plan

  variables {
    datasource_windows_event_map = {
      app-error = {
        event_log_name = "Application"
        event_types    = ["Error"]
      }
    }
  }

  assert {
    condition     = azurerm_log_analytics_datasource_windows_event.la_datasource_windows_event["app-error"].event_log_name == "Application"
    error_message = "event_log_name must be passed through"
  }
}

run "user_assigned_identity" {
  command = plan

  variables {
    identity = {
      type         = "UserAssigned"
      identity_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.ManagedIdentity/userAssignedIdentities/my-id"]
    }
  }

  assert {
    condition     = length(azurerm_log_analytics_workspace.log_analytics.identity) == 1
    error_message = "identity block must be emitted when UserAssigned identity is configured"
  }

  assert {
    condition     = azurerm_log_analytics_workspace.log_analytics.identity[0].type == "UserAssigned"
    error_message = "identity.type must be UserAssigned"
  }
}

run "workspace_id_output" {
  command = apply

  assert {
    condition     = output.workspace_id == azurerm_log_analytics_workspace.log_analytics.workspace_id
    error_message = "workspace_id output must equal the resource workspace_id attribute"
  }
}
