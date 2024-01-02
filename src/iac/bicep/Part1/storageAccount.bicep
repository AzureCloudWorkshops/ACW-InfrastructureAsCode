@minLength(3)
param storageAccountName string
param location string = resourceGroup().location
@minLength(11)
@maxLength(11)
param uniqueIdentifier string
@minLength(3)
@maxLength(4)
@allowed([
  'dev'
  'prod'
])
param environment string = 'dev'

var storageAccountNameFull = substring('${storageAccountName}${uniqueIdentifier}${environment}${uniqueString(resourceGroup().id)})}', 0, 24)

resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountNameFull
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

output storageAccountName string = storageaccount.name
output storageAccountId string = storageaccount.id
output storageAccountLocation string = storageaccount.location
