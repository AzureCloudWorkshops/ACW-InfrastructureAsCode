param location string
param uniqueIdentifier string 
param appServicePlanName string
param appServicePlanSku string = 'F1'
param webAppName string 
param appInsightsName string
param identityDBConnectionStringKey string = 'ConnectionStrings:DefaultConnection'
param managerDBConnectionStringKey string = 'ConnectionStrings:MyContactManager'
param appInsightsConnectionStringKey string  = 'APPINSIGHTS:CONNECTIONSTRING'

var workerRuntime = 'dotnet'
var webAppFullName = '${webAppName}-${uniqueIdentifier}'
var identityDBConnectionStringValue = 'ContactWebIdentityDBConnectionString'
var managerDBConnectionStringValue = 'ContactWebDBConnectionString'

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: appInsightsName
}

resource hostingPlan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: '${appServicePlanName}-${uniqueIdentifier}'
  location: location
  sku: {
    name: appServicePlanSku
  }
}

resource webApp 'Microsoft.Web/sites@2023-01-01' = {
  name: webAppFullName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: hostingPlan.id
    siteConfig: {
      metadata: [
        {
          name:'CURRENT_STACK'
          value:workerRuntime
        }
      ]
      netFrameworkVersion:'v6.0'
      appSettings: [
        {
          name: appInsightsConnectionStringKey
          value: applicationInsights.properties.ConnectionString
        }
        {
          name: identityDBConnectionStringKey
          value: identityDBConnectionStringValue
        }
        {
          name: managerDBConnectionStringKey
          value: managerDBConnectionStringValue
        }
      ]
      ftpsState: 'FtpsOnly'
      minTlsVersion: '1.2'
    }
    httpsOnly: true
  }
}

output webAppFullName string = webApp.name
