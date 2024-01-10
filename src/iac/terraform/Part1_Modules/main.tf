locals {  
  storageAccountNameEnv = substr("${var.storageAccountName}${var.uniqueIdentifier}${var.environment}${arm2tf_unique_string.uniqueid.id}",0,24)
}

resource "arm2tf_unique_string" "uniqueid" {
  input = [azurerm_resource_group.iac_rg.name]
}

resource "azurerm_resource_group" iac_rg {
  name     = var.resourceGroupName
  location = var.location
}

module "storageAccount" {
  source = "./modules/storageAccount"

  storageAccountNameEnv = local.storageAccountNameEnv
  resourceGroupName     = var.resourceGroupName
  location              = var.location
}

module "storageContainer" {
  source = "./modules/storageContainer"

  containerName      = var.containerName
  storageAccountName = module.storageAccount.stg_acct_name
}