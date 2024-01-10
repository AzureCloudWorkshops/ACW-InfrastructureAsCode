locals {
  storageAccountNameFull = "${var.storageAccountName}${var.uniqueIdentifier}"
  storageAccountNameUnique = substr("${var.storageAccountName}${var.uniqueIdentifier}${arm2tf_unique_string.uniqueid.id}",0,24)
  storageAccountNameEnv = substr("${var.storageAccountName}${var.uniqueIdentifier}${var.environment}${arm2tf_unique_string.uniqueid.id}",0,24)
}

data "azurerm_resource_group" "data_rg" {
  name = var.resourceGroupName
}

resource "arm2tf_unique_string" "uniqueid" {
  input = [data.azurerm_resource_group.data_rg.name]
}

resource "azurerm_storage_account" "cm_stg_acct" {
  name                     = var.storageAccountName
  resource_group_name      = data.azurerm_resource_group.data_rg.name
  location                 = data.azurerm_resource_group.data_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_account" "cm_stg_acct_full" {
  name                     = local.storageAccountNameFull
  resource_group_name      = data.azurerm_resource_group.data_rg.name
  location                 = data.azurerm_resource_group.data_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_account" "cm_stg_acct_unique" {
  name                     = local.storageAccountNameUnique
  resource_group_name      = data.azurerm_resource_group.data_rg.name
  location                 = data.azurerm_resource_group.data_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_account" "cm_stg_acct_env" {
  name                     = local.storageAccountNameEnv
  resource_group_name      = data.azurerm_resource_group.data_rg.name
  location                 = data.azurerm_resource_group.data_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}