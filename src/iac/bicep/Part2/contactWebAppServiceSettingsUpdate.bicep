param webAppName string 
param defaultDBSecretURI string
param managerDBSecretURI string
param identityDBConnectionStringKey string
param managerDBConnectionStringKey string 

resource webApp 'Microsoft.Web/sites@2023-01-01' existing = {
  name: webAppName
}

module updateAndMergeWebAppConfig 'contactWebAppServiceSettingsMerge.bicep' = {
  name: 'webAppSettings-${webAppName}'
  params: {
    currentAppSettings: list('${webApp.id}/config/appsettings', '2023-01-01').properties
    appSettings: {
      '${identityDBConnectionStringKey}' : '@Microsoft.KeyVault(SecretUri=${defaultDBSecretURI})'
      '${managerDBConnectionStringKey}': '@Microsoft.KeyVault(SecretUri=${managerDBSecretURI})'
    }
    webAppName: webApp.name
  }
}
