terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.92"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}


resource "azurerm_app_service_plan" "app_service_plan" {
  name                = "app-service-plan"
  location            = var.location
  resource_group_name = var.rg_name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "app" {
  name                    = var.app_name
  location                = azurerm_app_service_plan.app_service_plan.location
  resource_group_name     = var.rg_name
  app_service_plan_id     = azurerm_app_service_plan.app_service_plan.id
  https_only              = true
  client_affinity_enabled = true

  backup {
    enabled             = true
    name                = "daily_90days"
    storage_account_url = "https://sa${var.app_name}.blob.core.windows.net/sc-${var.app_name}${data.azurerm_storage_account_blob_container_sas.storage_container_sas.sas}"
    schedule {
      frequency_interval       = 1
      frequency_unit           = "Day"
      retention_period_in_days = 90
      keep_at_least_one_backup = true
    }
  }

  site_config {
    php_version       = "7.4"
    health_check_path = "/"
  }

  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY        = azurerm_application_insights.app_insight.instrumentation_key
    APPLICATIONINSIGHTS_CONNECTION_STRING = azurerm_application_insights.app_insight.connection_string
  }

  connection_string {
    name  = "mysql_connection"
    type  = "MySQL"
    value = "Database=sqldb_${var.app_name}; Data Source=sql-${var.app_name}.mysql.database.azure.com; User Id=${var.sql_server_login}@sql-${var.app_name}; Password=${var.sql_server_password}"
  }
}

resource "azurerm_application_insights" "app_insight" {
  name                = "app_insight-${var.app_name}"
  location            = var.location
  resource_group_name = var.rg_name
  application_type    = "web"
}