resource "azurerm_storage_container" "cm_stg_container" {
  name                  = var.containerName
  storage_account_name  = var.storageAccountName
}