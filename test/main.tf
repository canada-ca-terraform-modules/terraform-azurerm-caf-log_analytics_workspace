terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.46.0"
    }
  }
  required_version = ">= 0.14.1"
}

provider "azurerm" {
  features {}
}

module "law_test" {
  source            = "../."
  userDefinedString = "test_law"
  resource_group    = azurerm_resource_group.test-RG
  tags              = var.tags
  env               = var.env

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
      "publisher" = "Microsoft"
      "product"   = "OMSGallery/AgentHealthAssessment"
    },
    DnsAnalytics = {
      "publisher" = "Microsoft"
      "product"   = "OMSGallery/DnsAnalytics"
    },
    KeyVaultAnalytics = {
      "publisher" = "Microsoft"
      "product"   = "OMSGallery/KeyVaultAnalytics"
    },
    /*
    Updates = {
      "publisher" = "Microsoft"
      "product"   = "OMSGallery/Updates"
    },
    ChangeTracking = {
      "publisher" = "Microsoft"
      "product"   = "OMSGallery/ChangeTracking"
    }
    */
  }
}