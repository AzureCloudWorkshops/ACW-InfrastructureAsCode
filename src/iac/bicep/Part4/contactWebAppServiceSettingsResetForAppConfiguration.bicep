param webAppName string
param appConfigurationEndpointKey string 
param appConfigurationEndpointValue string 
param applicationInsightsConnectionStringKey string 
param applicationInsightsName string

resource webApp 'Microsoft.Web/sites@2023-01-01' existing = {
  name: webAppName
}

resource appInsights 'Microsoft.Insights/components@2020-02-02-preview' existing = {
  name: applicationInsightsName
}

//reset the current app settings with the new app settings WARNING: Wipes out everything that isn't explicitly set in the appSettings object
module resetAppConfigurationSettings 'contactWebAppServiceSettingsMerge.bicep' = {
  name: 'webAppSettings-${webAppName}'
  params: {
    currentAppSettings: { '${applicationInsightsConnectionStringKey}': appInsights.properties.ConnectionString }
    appSettings: {
      '${appConfigurationEndpointKey}' : appConfigurationEndpointValue
    }
    webAppName: webApp.name
  }
}
