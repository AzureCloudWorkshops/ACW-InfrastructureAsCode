output "stg_acct_name" {
  value = azurerm_storage_account.cm_stg_acct_env.name
}

output "stg_acct_id" {
  value = azurerm_storage_account.cm_stg_acct_env.id
}

output "stg_acct_location" {
  value = azurerm_storage_account.cm_stg_acct_env.location
}