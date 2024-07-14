locals {  
  storageAccountNameEnv = substr("${var.storageAccountName}${var.uniqueIdentifier}${var.environment}${random_string.random.result}",0,24)
}

resource "random_string" "random" {
  length           = 10
  special          = false
  lower            = true
  upper            = false 
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