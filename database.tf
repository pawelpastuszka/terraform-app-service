resource "azurerm_mysql_server" "sql_server" {
  name                              = "sql-${var.app_name}"
  location                          = azurerm_app_service_plan.app_service_plan.location
  resource_group_name               = var.rg_name
  version                           = "5.7"
  sku_name                          = "GP_Gen5_2"
  storage_mb                        = 5120
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false #for ACG sandbox
  infrastructure_encryption_enabled = true
  auto_grow_enabled                 = true
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"

  administrator_login          = var.sql_server_login
  administrator_login_password = var.sql_server_password
}

resource "azurerm_mysql_database" "sql_database" {
  name                = "sqldb_${var.app_name}"
  resource_group_name = var.rg_name
  server_name         = azurerm_mysql_server.sql_server.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}