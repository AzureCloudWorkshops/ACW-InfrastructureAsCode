output "keyVaultName" {
  value = azurerm_key_vault.cm_kv.name
}

output "identityDBConnectionSecretURI" {
  value = azurerm_key_vault_secret.kv_secret_identity.versionless_id
}

output "managerDBConnectionSecretURI" {
  value = azurerm_key_vault_secret.kv_secret_cm.versionless_id
}