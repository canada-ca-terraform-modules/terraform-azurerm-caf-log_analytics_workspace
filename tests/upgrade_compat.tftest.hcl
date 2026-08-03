# upgrade_compat.tftest.hcl
# Verifies that callers using pre-5.x tfvars format still produce a valid plan,
# ensuring no breaking changes were introduced during the azurerm 5.x upgrade.
# This module's original resource arguments (name, location, resource_group_name,
# sku, tags, retention_in_days) are unchanged in the azurerm v5 schema for
# azurerm_log_analytics_workspace, azurerm_log_analytics_solution and
# azurerm_log_analytics_datasource_windows_event — every new argument added by
# this upgrade is additive and gated with try(..., null).

mock_provider "azurerm" {}

# Simulate a legacy caller that only sets the original, pre-upgrade arguments —
# plan must succeed without changes and must not emit any of the new azurerm >= 5.x
# arguments.
run "legacy_caller_no_new_args" {
  command = plan

  variables {
    env               = "Prod"
    userDefinedString = "legacy"
    resource_group = {
      id       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-legacy"
      name     = "rg-legacy"
      location = "canadacentral"
    }
    tags = {
      environment = "prod"
    }
    solution_plan_map = {
      AzureActivity = {
        publisher = "Microsoft"
        product   = "OMSGallery/AzureActivity"
      }
    }
    datasource_windows_event_map = {
      app-error = {
        event_log_name = "Application"
        event_types    = ["Error"]
      }
    }
    # No new azurerm >= 5.x args supplied
  }

  assert {
    condition     = azurerm_log_analytics_workspace.log_analytics.sku == "PerGB2018"
    error_message = "Legacy caller must keep the default sku"
  }

  assert {
    condition     = azurerm_log_analytics_workspace.log_analytics.local_authentication_enabled == null
    error_message = "New azurerm >= 5.x args must remain unset (null) for legacy callers"
  }

  assert {
    condition     = length(azurerm_log_analytics_workspace.log_analytics.identity) == 0
    error_message = "identity block must not be emitted for legacy callers that never set it"
  }

  assert {
    condition     = azurerm_log_analytics_solution.la_solution["AzureActivity"].solution_name == "AzureActivity"
    error_message = "Legacy solution_plan_map usage must still resolve correctly"
  }

  assert {
    condition     = azurerm_log_analytics_datasource_windows_event.la_datasource_windows_event["app-error"].event_log_name == "Application"
    error_message = "Legacy datasource_windows_event_map usage must still resolve correctly"
  }
}

# Simulate a legacy caller that explicitly set retention_in_days as a string
# (the module's variable type has always been string, coerced to number for the
# provider) — must still work identically after the upgrade.
run "legacy_retention_in_days_string" {
  command = plan

  variables {
    env               = "Dev"
    userDefinedString = "legacy2"
    resource_group = {
      id       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-legacy2"
      name     = "rg-legacy2"
      location = "canadacentral"
    }
    tags = {
      environment = "dev"
    }
    retention_in_days = "30"
  }

  assert {
    condition     = azurerm_log_analytics_workspace.log_analytics.retention_in_days == 30
    error_message = "Legacy string retention_in_days must still coerce correctly to a number"
  }
}
