targetScope = 'subscription'

param rgName string
param location string

@minLength(3)
param storageAccountName string
@minLength(11)
@maxLength(11)
param uniqueIdentifier string
@minLength(3)
@maxLength(4)
@allowed([
  'dev'
  'prod'
])
param deploymentEnvironment string
param containerName string

resource iacTrainingResourceGroup 'Microsoft.Resources/resourceGroups@2018-05-01' = {
  name: rgName
  location: location
}

module iacTrainingModuleStorage 'storageAccount.bicep' = {
  name: 'iacTrainingStorage'
  scope: iacTrainingResourceGroup
  params: {
    storageAccountName: storageAccountName
    uniqueIdentifier: uniqueIdentifier
    environment: deploymentEnvironment
    location: iacTrainingResourceGroup.location
  }
}

module iacTrainingModuleStorageContainer 'storageAccountContainer.bicep' = {
  name: 'iacTrainingStorageContainer-${containerName}'
  scope: iacTrainingResourceGroup
  params: {
    storageAccountFullName: iacTrainingModuleStorage.outputs.storageAccountName
    containerName: containerName
  }
}
