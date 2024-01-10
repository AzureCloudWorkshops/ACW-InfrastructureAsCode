resource "azurerm_storage_account" "cm_stg_acct_env" {
  name                     = var.storageAccountNameEnv
  resource_group_name      = var.resourceGroupName
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}