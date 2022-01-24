resource "azurerm_mysql_server" "sql_server" {
  name                              = "${var.resource_prefix}-db-server"
  location                          = var.location
  resource_group_name               = var.resource_group_name
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

  administrator_login          = random_string.string.result
  administrator_login_password = random_password.password.result
}

resource "azurerm_mysql_database" "sql_database" {
  name                = "${var.resource_prefix}_db"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_server.sql_server.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

resource "random_string" "dbuser" {
  length  = 10
  special = false
}

resource "random_password" "dbpassword" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "azurerm_key_vault_secret" "dbsecret" {
  name         = "${module.resource-prefix.prefix}-dbuser"
  value        = random_password.dbuser.result
  key_vault_id = var.keyvault_id
}

resource "azurerm_key_vault_secret" "dbsecret" {
  name         = "${module.resource-prefix.prefix}-dbsecret"
  value        = random_password.dbuser.result
  key_vault_id = var.keyvault_id
}
