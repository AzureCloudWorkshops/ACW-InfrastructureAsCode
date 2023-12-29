param webAppName string 
param defaultDBSecretURI string
param managerDBSecretURI string

resource webApp 'Microsoft.Web/sites@2023-01-01' existing = {
  name: webAppName
}

module updateAndMergeWebAppConfig 'contactWebAppServiceSettingsMerge.bicep' = {
  name: 'webAppSettings-${webAppName}'
  params: {
    currentAppSettings: list('${webApp.id}/config/appsettings', '2023-01-01').properties
    appSettings: {
      'ConnectionStrings:DefaultConnection': '@Microsoft.KeyVault(SecretUri=${defaultDBSecretURI})'
      'ConnectionStrings:MyContactManager': '@Microsoft.KeyVault(SecretUri=${managerDBSecretURI})'
    }
    webAppName: webApp.name
  }
}
