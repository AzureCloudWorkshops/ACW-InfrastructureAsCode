data "azurerm_client_config" "current" {}

data "azurerm_windows_web_app" "cm_webapp" {
  name                = "${var.webAppName}-${var.uniqueIdentifier}"
  resource_group_name = var.resourceGroupName
}

resource "azurerm_app_configuration" "cm_app_config" {
  name                       = "${var.appConfigStoreName}-${var.uniqueIdentifier}"
  resource_group_name        = var.resourceGroupName
  location                   = var.location
  sku                        = "standard"
  local_auth_enabled         = true
  public_network_access      = "Enabled"
  purge_protection_enabled   = false
  soft_delete_retention_days = 1

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "app_config_access_webapp" {
  scope                = azurerm_app_configuration.cm_app_config.id
  role_definition_name = "App Configuration Data Reader"
  principal_id         = data.azurerm_windows_web_app.cm_webapp.identity[0].principal_id
}

resource "azurerm_role_assignment" "kv_access_appconfig" {
  scope                = var.keyVaultId
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_app_configuration.cm_app_config.identity[0].principal_id
}

resource "azurerm_role_assignment" "appconfig_dataowner" {
  scope                = azurerm_app_configuration.cm_app_config.id
  role_definition_name = "App Configuration Data Owner"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_app_configuration_key" "appconfig_key_defaultConnection" {
  configuration_store_id = azurerm_app_configuration.cm_app_config.id
  key                    = "ConnectionStrings:DefaultConnection"
  type                   = "vault"
  vault_key_reference    = var.identityDbSecretURI

  depends_on = [
    azurerm_role_assignment.appconfig_dataowner
  ]
}

resource "azurerm_app_configuration_key" "appconfig_key_cm" {
  configuration_store_id = azurerm_app_configuration.cm_app_config.id
  key                    = "ConnectionStrings:MyContactManager"
  type                   = "vault"
  vault_key_reference    = var.managerDbSecretURI

  depends_on = [
    azurerm_role_assignment.appconfig_dataowner
  ]
}