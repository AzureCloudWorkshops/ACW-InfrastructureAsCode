resource "azurerm_application_insights" "cm_app_insights" {
  name                = var.appInsightsName
  location            = var.location
  resource_group_name = var.resourceGroupName
  workspace_id        = var.logAnalyticsWorkspaceId
  application_type    = "web"
}