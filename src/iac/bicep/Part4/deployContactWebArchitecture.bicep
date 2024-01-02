targetScope = 'subscription'

param rgName string
param location string

@minLength(11)
@maxLength(11)
@description('YYYYMMDD with your initials to follow (i.e. 20291231acw)')
param uniqueIdentifier string

param sqlServerName string
param sqlDatabaseName string
param sqlServerAdminLogin string
@secure()
param sqlServerAdminPassword string
param clientIPAddress string

param logAnalyticsWorkspaceName string
param appInsightsName string

param webAppName string
param appServicePlanName string
param appServicePlanSku string
param identityDBConnectionStringKey string
param managerDBConnectionStringKey string
param appInsightsConnectionStringKey string

param keyVaultName string
param keyVaultUserManagedIdentityName string
param developersGroupObjectId string
var keyVaultUMIFullName = '${keyVaultName}-${keyVaultUserManagedIdentityName}'

@minLength(5)
@maxLength(12)
param appConfigStoreName string
param appDataReaderRoleDefinitionName string
param appDataReaderRoleId string
param appConfigurationEndpointKey string

resource contactWebResourceGroup 'Microsoft.Resources/resourceGroups@2018-05-01' = {
  name: rgName
  location: location
}

module contactWebDatabase 'azureSQL.bicep' = {
  name: '${sqlServerName}-${sqlDatabaseName}-${uniqueIdentifier}'
  scope: contactWebResourceGroup
  params: {
    location: contactWebResourceGroup.location
    uniqueIdentifier: uniqueIdentifier
    sqlServerName: sqlServerName
    sqlDatabaseName: sqlDatabaseName
    sqlServerAdminLogin: sqlServerAdminLogin
    sqlServerAdminPassword: sqlServerAdminPassword
    clientIPAddress: clientIPAddress
  }
}

module contactWebAnalyticsWorkspace 'logAnalyticsWorkspace.bicep' = {
  name: '${logAnalyticsWorkspaceName}-deployment'
  scope: contactWebResourceGroup
  params: {
    location: contactWebResourceGroup.location
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
  }
}

module contactWebApplicationInsights 'applicationInsights.bicep' = {
  name: '${appInsightsName}-deployment'
  scope: contactWebResourceGroup
  params: {
    location: contactWebResourceGroup.location
    appInsightsName: appInsightsName
    logAnalyticsWorkspaceId: contactWebAnalyticsWorkspace.outputs.logAnalyticsWorkspaceId
  }
}

module contactWebApplicationPlanAndSite 'contactWebAppService.bicep' = {
  name: '${webAppName}-deployment'
  scope: contactWebResourceGroup
  params: {
    location: contactWebResourceGroup.location
    uniqueIdentifier: uniqueIdentifier
    appInsightsName: contactWebApplicationInsights.outputs.applicationInsightsName
    appServicePlanName: appServicePlanName
    appServicePlanSku: appServicePlanSku
    webAppName: webAppName
    identityDBConnectionStringKey: identityDBConnectionStringKey
    managerDBConnectionStringKey: managerDBConnectionStringKey
    appInsightsConnectionStringKey: appInsightsConnectionStringKey
  }
}

module contactWebVault 'keyVault.bicep' = {
  name: '${keyVaultName}-deployment'
  scope: contactWebResourceGroup
  params: {
    location: contactWebResourceGroup.location
    uniqueIdentifier: uniqueIdentifier
    webAppFullName: contactWebApplicationPlanAndSite.outputs.webAppFullName
    databaseServerName: contactWebDatabase.outputs.sqlServerName
    keyVaultName: keyVaultName
    sqlDatabaseName: sqlDatabaseName
    sqlServerAdminPassword: sqlServerAdminPassword
    developersGroupObjectId: developersGroupObjectId
    keyVaultUserManagedIdentityName: keyVaultUMIFullName
  }
}

module updateContactWebAppSettings 'contactWebAppServiceSettingsUpdate.bicep' = {
  name: '${webAppName}-updatingAppSettings'
  scope: contactWebResourceGroup
  params: {
    webAppName: contactWebApplicationPlanAndSite.outputs.webAppFullName
    defaultDBSecretURI: contactWebVault.outputs.identityDBConnectionSecretURI
    managerDBSecretURI: contactWebVault.outputs.managerDBConnectionSecretURI
    identityDBConnectionStringKey: identityDBConnectionStringKey
    managerDBConnectionStringKey: managerDBConnectionStringKey
  }
}

module orgAppConfiguration 'appConfigStore.bicep' = {
  name: '${appConfigStoreName}-deployment'
  scope: contactWebResourceGroup
  params: {
    location: contactWebResourceGroup.location
    uniqueIdentifier: uniqueIdentifier
    appConfigStoreName: appConfigStoreName
    identityDBConnectionStringKey: identityDBConnectionStringKey
    managerDBConnectionStringKey: managerDBConnectionStringKey
    identityDbSecretURI: contactWebVault.outputs.identityDBConnectionSecretURI
    managerDbSecretURI: contactWebVault.outputs.managerDBConnectionSecretURI
    keyVaultUserManagedIdentityName: contactWebVault.outputs.keyVaultUserManagedIdentityName
    webAppName: contactWebApplicationPlanAndSite.outputs.webAppFullName
    roleDefinitionName: appDataReaderRoleDefinitionName
    appDataReaderRoleId: appDataReaderRoleId
  }
}

module resetContactWebAppSettingsForAppConfiguration 'contactWebAppServiceSettingsResetForAppConfiguration.bicep' = {
  name: '${webAppName}-resettingAppSettingsForAppConfiguration'
  scope: contactWebResourceGroup
  params: {
    webAppName: contactWebApplicationPlanAndSite.outputs.webAppFullName
    appConfigurationEndpointKey: appConfigurationEndpointKey
    appConfigurationEndpointValue: orgAppConfiguration.outputs.appConfigStoreEndpoint
    applicationInsightsConnectionStringKey: appInsightsConnectionStringKey
    applicationInsightsName: contactWebApplicationInsights.outputs.applicationInsightsName
  }
}
