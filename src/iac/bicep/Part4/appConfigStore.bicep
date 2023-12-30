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
param webAppName string
param roleDefinitionName string
param appDataReaderRoleId string

var configName = '${appConfigStoreName}-${uniqueIdentifier}'
var roleAssignmentId = guid('${webApp.name}', '${appDataReaderRole.name}','${appConfig.name}')

resource appDataReaderRole 'Microsoft.Authorization/roleDefinitions@2022-05-01-preview' existing = {
  name: roleDefinitionName
}

resource webApp 'Microsoft.Web/sites@2023-01-01' existing = {
  name: webAppName
}

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
    value: '{"uri": "${identityDbSecretURI}"}'
  }
}

resource managerDBConnectionKeyValuePair 'Microsoft.AppConfiguration/configurationStores/keyValues@2023-03-01' = {
  name: managerDBConnectionStringKey
  parent: appConfig
  properties: {
    contentType: 'application/vnd.microsoft.appconfig.keyvaultref+json;charset=utf-8'
    value: '{"uri": "${managerDbSecretURI}"}'
  }
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: roleAssignmentId
  scope: appConfig
  properties: {
    principalId: webApp.identity.principalId
    roleDefinitionId: appDataReaderRoleId
    principalType: 'ServicePrincipal'
  }
}

output appConfigStoreName string = appConfig.name
output appConfigStoreEndpoint string = appConfig.properties.endpoint
output dataReaderRoleName string = appDataReaderRole.name
output dataReaderRoleId string = appDataReaderRole.id
