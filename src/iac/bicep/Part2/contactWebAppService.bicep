param location string
param uniqueIdentifier string 
param appServicePlanName string
param appServicePlanSku string = 'F1'
param webAppName string 
param appInsightsName string

var workerRuntime = 'dotnet'
var webAppFullName = '${webAppName}-${uniqueIdentifier}'

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
      metadata :[
        {
          name:'CURRENT_STACK'
          value:workerRuntime
        }
      ]
      netFrameworkVersion:'v6.0'
      appSettings: [
          {
            name: 'APPINSIGHTS:CONNECTIONSTRING'
            value: applicationInsights.properties.ConnectionString
          }
          {
            name: 'ConnectionStrings:DefaultConnection'
            value: 'ContactWebIdentityDBConnectionString'
          }
          {
            name: 'ConnectionStrings:MyContactManager'
            value: 'ContactWebDBConnectionString'
          }
        ]
        ftpsState: 'FtpsOnly'
        minTlsVersion: '1.2'
    }
    httpsOnly: true
  }
}

output webAppFullName string = webApp.name
