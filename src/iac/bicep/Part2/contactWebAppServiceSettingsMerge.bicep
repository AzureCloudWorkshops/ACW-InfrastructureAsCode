param webAppName string
param appSettings object
param currentAppSettings object

resource webApp 'Microsoft.Web/sites@2023-01-01' existing = {
  name: webAppName
}

//merge the current app settings with the new app settings
resource siteconfig 'Microsoft.Web/sites/config@2023-01-01' = {
  parent: webApp
  name: 'appsettings'
  properties: union(currentAppSettings, appSettings)
}
