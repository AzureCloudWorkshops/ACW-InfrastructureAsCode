resource "azurerm_log_analytics_workspace" "cm_analytics_workspace" {
  name                            = var.logAnalyticsWorkSpaceName
  location                        = var.location
  resource_group_name             = var.resourceGroupName
  sku                             = "PerGB2018"
  retention_in_days               = 30
  allow_resource_only_permissions = true  
}