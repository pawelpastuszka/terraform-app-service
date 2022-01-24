resource "azurerm_resource_group" "main_rg" {
    name = "${var.resource_project_prefix}-rg"
    location = var.location
    tags = var.tags
}
