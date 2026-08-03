log_analytics_workspaces = {
  # --- EXISTING ENTRY (unchanged) ---
  Logs = {
    resource_group = "Logs-rg"
    # custom_name = "" # Optional: Override the auto-generated name (default: {env4}CLD-{userDefinedString}-{unique}-law)

    solution_plan_map = {
      ServiceMap = {
        publisher = "Microsoft"
        product   = "OMSGallery/ServiceMap"
      },
      AzureActivity = {
        publisher = "Microsoft"
        product   = "OMSGallery/AzureActivity"
      },
      AgentHealthAssessment = {
        publisher = "Microsoft"
        product   = "OMSGallery/AgentHealthAssessment"
      },
      DnsAnalytics = {
        publisher = "Microsoft"
        product   = "OMSGallery/DnsAnalytics"
      },
      KeyVaultAnalytics = {
        publisher = "Microsoft"
        product   = "OMSGallery/KeyVaultAnalytics"
      },
    }
  }

  # --- NEW ARGUMENT EXAMPLES (azurerm >= 5.x, commented out) ---
  # example_with_new_features = {
  #   resource_group                          = "Logs-rg"
  #   sku                                      = "PerGB2018"
  #   retention_in_days                        = 30
  #   local_authentication_enabled             = true
  #   allow_resource_only_permissions          = true
  #   daily_quota_gb                           = 5
  #   cmk_for_query_forced                     = false
  #   internet_ingestion_access_type           = "Enabled"  # Enabled | Disabled | SecuredByPerimeter
  #   internet_query_access_type               = "Enabled"  # Enabled | Disabled | SecuredByPerimeter
  #   data_collection_rule_id                  = "/subscriptions/.../resourceGroups/.../providers/Microsoft.Insights/dataCollectionRules/example"
  #   immediate_data_purge_on_30_days_enabled  = false
  #
  #   # reservation_capacity_in_gb_per_day only applies when sku = "CapacityReservation"
  #   # sku                                = "CapacityReservation"
  #   # reservation_capacity_in_gb_per_day = 100
  #
  #   identity = {
  #     type = "SystemAssigned" # SystemAssigned | UserAssigned
  #     # identity_ids = []      # Required when type = UserAssigned
  #   }
  # }
}
