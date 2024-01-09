data "azurerm_client_config" "current" {}

data "azurerm_mssql_server" "cm_sql_server" {
  resource_group_name = var.resourceGroupName
  name                = "${var.sqlServerName}${var.uniqueIdentifier}"
}

locals {
  dbConnectionString = "Server=tcp:${data.azurerm_mssql_server.cm_sql_server.fully_qualified_domain_name},1433;Initial Catalog=${var.sqlDatabaseName};Persist Security Info=False;User ID=${data.azurerm_mssql_server.cm_sql_server.administrator_login};Password=${var.sqlServerPwd};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"  
}

resource "azurerm_key_vault" "cm_kv" {
  name                            = "${var.keyVaultName}${var.uniqueIdentifier}"
  location                        = var.location
  resource_group_name             = var.resourceGroupName
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  sku_name                        = "standard"
  soft_delete_retention_days      = 7
  purge_protection_enabled        = true  
  enable_rbac_authorization       = true
  enabled_for_template_deployment = true
}

resource "azurerm_key_vault_secret" "kv_secret_identity" {
  name         = "IdentityDbConnectionSecret"
  value        = local.dbConnectionString
  key_vault_id = azurerm_key_vault.cm_kv.id

  depends_on = [ azurerm_role_assignment.kv_access_current_user ]
}

resource "azurerm_key_vault_secret" "kv_secret_cm" {
  name         = "ContactManagerDbConnectionSecret"
  value        = local.dbConnectionString
  key_vault_id = azurerm_key_vault.cm_kv.id

  depends_on = [ azurerm_role_assignment.kv_access_current_user ]
}

resource "azurerm_role_assignment" "kv_access_current_user" {
  scope                = azurerm_key_vault.cm_kv.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}