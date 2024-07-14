locals {
  storageAccountNameFull = "${var.storageAccountName}${var.uniqueIdentifier}"
  storageAccountNameUnique = substr("${var.storageAccountName}${var.uniqueIdentifier}${random_string.random.result}",0,24)
  storageAccountNameEnv = substr("${var.storageAccountName}${var.uniqueIdentifier}${var.environment}${random_string.random.result}",0,24)
}

resource "random_string" "random" {
  length           = 10
  special          = false
  lower            = true
  upper            = false 
}

data "azurerm_resource_group" "data_rg" {
  name = var.resourceGroupName
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