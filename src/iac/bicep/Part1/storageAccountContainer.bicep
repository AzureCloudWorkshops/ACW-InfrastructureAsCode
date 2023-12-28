param storageAccountFullName string
@minLength(3)
@maxLength(63)
param containerName string

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' existing = {
  name: storageAccountFullName
}

resource blobServices 'Microsoft.Storage/storageAccounts/blobServices@2021-04-01' = {
  parent: storageAccount
  name: 'default'
  properties: {
    deleteRetentionPolicy: {
      enabled: false
      days: 7
    }
  }
}

resource blobContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  name: containerName
  parent: blobServices
  properties: {
    metadata: {}
    publicAccess: 'None'
  }
}
