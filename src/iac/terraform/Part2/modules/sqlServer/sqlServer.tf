locals {
  sqlServerUniqueName   = "${var.sqlServerName}${var.uniqueIdentifier}"
}

# Azure SQL Server
resource "azurerm_mssql_server" cm_sql_server {
  name                                  = local.sqlServerUniqueName
  resource_group_name                   = var.resourceGroupName
  location                              = var.location
  version                               = "12.0"
  administrator_login                   = var.sqlServerAdmin
  administrator_login_password          = var.sqlServerPwd
  outbound_network_restriction_enabled  = false
  minimum_tls_version                   = "1.2"
  public_network_access_enabled         = true
}

resource "azurerm_mssql_firewall_rule" "allowAzureServices" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.cm_sql_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_mssql_firewall_rule" "allowClientMachine" {
  name             = "AllowClientMachine"
  server_id        = azurerm_mssql_server.cm_sql_server.id
  start_ip_address = var.clientIpAddress
  end_ip_address   = var.clientIpAddress
}

resource "azurerm_mssql_database" "cm_db" {
  name                        = var.sqlDatabaseName
  server_id                   = azurerm_mssql_server.cm_sql_server.id
  collation                   = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb                 = 2
  read_scale                  = false
  sku_name                    = var.sqlDbSkuName
  zone_redundant              = false
  auto_pause_delay_in_minutes = 60
  ledger_enabled              = false
  min_capacity                = 0.5
}