param location string 
@minLength(11)
@maxLength(11)
param uniqueIdentifier string 
@minLength(5)
@maxLength(12)
param appConfigStoreName string 
param identityDBConnectionStringKey string
param managerDBConnectionStringKey string 
param identityDbSecretURI string
param managerDbSecretURI string
param keyVaultUserManagedIdentityName string

var configName = '${appConfigStoreName}-${uniqueIdentifier}'

resource keyVaultUser 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = {
  name: keyVaultUserManagedIdentityName
}

resource appConfig 'Microsoft.AppConfiguration/configurationStores@2023-03-01' = {
  name: configName
  location: location
  sku: {
    name: 'free'
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${keyVaultUser.id}': {}
    }
  }
  properties: {
    encryption: {}
    disableLocalAuth: false
    softDeleteRetentionInDays: 0
    enablePurgeProtection: false
  }
}

resource identityDBConnectionKeyValuePair 'Microsoft.AppConfiguration/configurationStores/keyValues@2023-03-01' = {
  name: identityDBConnectionStringKey
  parent: appConfig
  properties: {
    contentType: 'application/vnd.microsoft.appconfig.keyvaultref+json;charset=utf-8'
    value: string('${identityDbSecretURI}')
  }
}

resource managerDBConnectionKeyValuePair 'Microsoft.AppConfiguration/configurationStores/keyValues@2023-03-01' = {
  name: managerDBConnectionStringKey
  parent: appConfig
  properties: {
    contentType: 'application/vnd.microsoft.appconfig.keyvaultref+json;charset=utf-8'
    value: string('${managerDbSecretURI}')
  }
}

output appConfigStoreName string = appConfig.name
output appConfigStoreEndpoint string = appConfig.properties.endpoint
