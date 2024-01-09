resource "azurerm_resource_group" "rg-contact-web-application" {
  name     = var.resource_group_name
  location = var.location
}

module "sqlServer" {
  source = "./modules/sqlServer"

  resourceGroupName = azurerm_resource_group.rg-contact-web-application.name
  location          = azurerm_resource_group.rg-contact-web-application.location
  clientIpAddress   = var.clientIpAddress
  sqlServerName     = var.sqlServerName
  sqlServerAdmin    = var.sqlServerAdmin 
  sqlServerPwd      = var.sqlServerPwd
  sqlDatabaseName   = var.sqlDatabaseName
  sqlDbSkuName      = var.sqlDbSkuName
  uniqueIdentifier  = var.uniqueIdentifier
}

module "logAnalyticsWorkspace" {
  source = "./modules/logAnalyticsWorkspace"

  resourceGroupName         = azurerm_resource_group.rg-contact-web-application.name
  location                  = azurerm_resource_group.rg-contact-web-application.location
  logAnalyticsWorkSpaceName = var.logAnalyticsWorkSpaceName
}

module "applicationInsights" {
  source = "./modules/appInsights"

  resourceGroupName         = azurerm_resource_group.rg-contact-web-application.name
  location                  = azurerm_resource_group.rg-contact-web-application.location
  logAnalyticsWorkspaceId   = module.logAnalyticsWorkspace.logAnalyticsWorkspaceId
  appInsightsName           = var.appInsightsName 
}

module "keyvault" {
  source = "./modules/keyvault"

  resourceGroupName = azurerm_resource_group.rg-contact-web-application.name
  location          = azurerm_resource_group.rg-contact-web-application.location
  sqlServerName     = var.sqlServerName
  sqlServerPwd      = var.sqlServerPwd
  sqlDatabaseName   = var.sqlDatabaseName
  uniqueIdentifier  = var.uniqueIdentifier
  keyVaultName      = var.keyVaultName
}