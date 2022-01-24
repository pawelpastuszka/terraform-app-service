resource "azurerm_storage_account" "storage_account" {
  name                     = "sa${var.project}"
  resource_group_name      = var.rg_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_storage_container" "storage_container" {
  name                  = "sc-${var.project}"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}

data "azurerm_storage_account_blob_container_sas" "storage_container_sas" {
  connection_string = azurerm_storage_account.storage_account.primary_connection_string
  container_name    = azurerm_storage_container.storage_container.name
  https_only        = true

  start  = "2022-01-01"
  expiry = "2023-01-01"

  permissions {
    read   = true
    add    = true
    create = true
    write  = true
    delete = true
    list   = true
  }
}
