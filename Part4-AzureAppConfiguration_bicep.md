# Azure App Configuration

Welcome to the bonus track! If you made it this far, that's great! You are now ready to learn about Azure App Configuration. This is a service that allows you to store your application settings and feature flags in a central place. It is a great way to decouple your application from its configuration data. It also provides a way to manage the configurations without having to redeploy your application.  Another great use for the App Configuration is for sharing configurations between multiple applications.  

In this section, you will learn how to create an App Configuration instance and how to use it in your application.  You will then reset the configuration values from the App Service to leverage the App Configuration instead of the Key Vault directly (don't worry, the Key Vault is still used to store the secrets).  You will also need to make a small code change so that the application can leverage the App Configuration.  

## Part 1 - Update the Bicep for the Key Vault

In hindsight, it would have been better to have a managed identity that could be used by both the App Service and the App Configuration.  However, we are going to keep the system managed identity for the App Service and add a new user managed identity for the App Configuration.  This will allow us to use the App Configuration to get the secrets from the Key Vault.  Any additional resources that would need to access the Key Vault would use the managed identity going forward.

>**Note:** User managed identities can be shared by resources to allow for configurations and permissions like this for multiple services. However, they pose a small security risk because they are not automatically cleaned up when resources are deleted.

You will also want to add yourself to the permissions.  For this I recommend adding a group and putting your user in the group, then getting the object id for the group.  This will allow you to add other users to the group in the future without having to update the permissions in the Key Vault, as well as remove those who leave the organization, etc.

## Task 1 - Update the Existing Key Vault Bicep

In this task, you'll update the bicep to let your group and a user managed identity have appropriate permissions to the Key Vault secrets, keys, and certificates.

### Step 1 - Create your user group

In this step you'll set up your user for permission access via a group membership.

1. In the Azure Portal, navigate to Groups

    Add a new group and add yourself to the group.

    !["Create a group and add yourself to it"](images/Part4-bicep/image0000-GroupCreation.png)  

1. Get the object ID for the group

    You will use this as a parameter to your IaC.  In reality you could also have done all of this with the CLI or via other bicep files.  However, let's draw the line since this is pretty much a one-time thing per tenant/subscription.

### Step 2 - Modify the Key Vault Bicep

In this step you'll modify the key vault bicep to create the user managed identity, and add the group and user managed identity to the permissions.

1. Two things are changing. The first is the creation of the user managed identity.  The second is the permissions.  You'll add the group and the user managed identity to the permissions.

    Update the bicep to include the following:

```bicep
param location string
@description('Provide a unique datetime and initials string to make your instances unique. Use only lower case letters and numbers')
@minLength(11)
@maxLength(11)
param uniqueIdentifier string 

@minLength(10)
@maxLength(13)
param keyVaultName string

param webAppFullName string
param databaseServerName string
param sqlDatabaseName string
@secure()
param sqlServerAdminPassword string

param developersGroupObjectId string
param keyVaultUserManagedIdentityName string

var vaultName = '${keyVaultName}${uniqueIdentifier}'
var skuName = 'standard'
var softDeleteRetentionInDays = 7

resource webApp 'Microsoft.Web/sites@2023-01-01' existing = {
  name: webAppFullName
}

resource databaseServer 'Microsoft.Sql/servers@2023-05-01-preview' existing = {
  name: databaseServerName
}

resource keyVaultUser 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: keyVaultUserManagedIdentityName
  location: location
}

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: vaultName
  location: location
  properties: {
    enabledForDeployment: true
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: true
    tenantId: subscription().tenantId
    enableSoftDelete: true
    softDeleteRetentionInDays: softDeleteRetentionInDays
    sku: {
      name: skuName
      family: 'A'
    }
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: webApp.identity.principalId
        permissions: {
          keys: []
          secrets: ['Get']
          certificates: []
        }
      }
      {
        tenantId: subscription().tenantId
        objectId: keyVaultUser.properties.principalId
        permissions: {
          keys: []
          secrets: ['Get']
          certificates: []
        }
      }
      {
        tenantId: subscription().tenantId
        objectId: developersGroupObjectId
        permissions: {
          keys: ['all']
          secrets: ['all']
          certificates: ['all']
        }
      }
    ]
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
  }
}

resource identityDBConnectionSecret 'Microsoft.KeyVault/vaults/secrets@2022-11-01' = {
  name: 'IdentityDbConnectionSecret'
  parent: keyVault
  properties: {
    value: 'Server=tcp:${databaseServer.name}${environment().suffixes.sqlServerHostname},1433;Initial Catalog=${sqlDatabaseName};Persist Security Info=False;User ID=${databaseServer.properties.administratorLogin};Password=${sqlServerAdminPassword};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;'
  }
}

resource contactManagerDBConnectionSecret 'Microsoft.KeyVault/vaults/secrets@2022-11-01' = {
  name: 'ContactManagerDbConnectionSecret'
  parent: keyVault
  properties: {
    value: 'Server=tcp:${databaseServer.name}${environment().suffixes.sqlServerHostname},1433;Initial Catalog=${sqlDatabaseName};Persist Security Info=False;User ID=${databaseServer.properties.administratorLogin};Password=${sqlServerAdminPassword};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;'
  }
}

output keyVaultName string = keyVault.name
output identityDBConnectionSecretURI string = identityDBConnectionSecret.properties.secretUri
output managerDBConnectionSecretURI string = contactManagerDBConnectionSecret.properties.secretUri
output keyVaultUserManagedIdentityName string = keyVaultUser.name
```  

1. Review the code updates

    Notice the new `keyVaultUser` identity that is created using the vault name and the `GetSecretsOnly` as part of the name to help discern what hte UMI is for.  Also notice that the `keyVaultUser` is added to the permissions with `Get` permissions for secrets.  This is the only permission that is needed for the App Configuration to get the secrets from the Key Vault.

    !["Key Vault user managed identity"](images/Part4-bicep/image0002-usermanagedidentityforvaultaccess.png)  

    Note that the group id is also added to the vault permissions with `all` permissions for keys, secrets, and certificates.  This is so that you can add other users to the group and they will have the same permissions, and you can interact with the vault and secrets from your local code as well as through the portal and app configuration (even if hte App Configuration has rights if you don't you can't do anything with the secrets).

    !["Key Vault permission updates"](images/Part4-bicep/image0001-keyvaultpermissions.png)  

1. Modify the params to include the new parameters

    Add the following to the params for the main deployment:

```bicep
param developersGroupObjectId string
param keyVaultUserManagedIdentityName string
```  

    These values will be passed in and the name is output because it will be configured and to avoid any possible mistakes it's easier to just leverage the name once it's created.

1. Modify the parameters file to include the new parameters

    Add the following to the parameters file (don't forget to add the comma to the previous line):

```json
        "developersGroupObjectId": {
            "value": "some-object-id-passed-in"
        },
        "keyVaultUserManagedIdentityName": {
            "value": "some umi name passed in"
        }
``````

1. Modify the main deployment

    Update the `deployContactWebArchitecture.bicep` file to include the new parameters and pass them in to the Key Vault bicep.

```bicep
param keyVaultUserManagedIdentityName string
param developersGroupObjectId string
var keyVaultUMIFullName = '${keyVaultName}-${keyVaultUserManagedIdentityName}'
```

    Note that the parameter used for the keyvault name will be decorated with the name of the vault at this top level.

    Update the call to the Key Vault bicep to include the new parameters:

```bicep  
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
```  

1. Modify the deployContactWebArchitecture.parameters.json file

    Update the parameters file to include the new parameters:

```json
        "developersGroupObjectId": {
            "value": "your-object-id-here"
        },
        "keyVaultUserManagedIdentityName": {
            "value": "GetSecretsOnlyIdentity"
        },
```

    Make sure that you put your actual object id in the developersGroupObjectId parameter.

1. Deploy the changes & validate

    Push the changes and validate that you have the new user managed identity and the permissions are correct.

    !["Managed Identities"](images/Part4-bicep/image0004-managedIdentity.png)  

1. Validate Key Vault access permissions include the UMI, the web app, and your user group as expected.

    !["Key Vault permissions"](images/Part4-bicep/image0003-kvaccesspolicies.png)  
    
## Task 2 - Create an App Configuration instance

In this task, you'll create an app configuration with references to the Key Vault secrets for the two database connections.  You could do additional shared settings here as well that wouldn't have to be key vault secrets, but could just be setting key-value pairs.  For this training, we're just doing the two database connections.

### Step 1 - Create the bicep

- App configuration with Identity
- Permission to get secrets from Key vault
- Two KeyVault references to the Key Vault secrets

### Step 2 - Create the params

### Step 3 - modify the main deployment

### Step 4 - Validate the deployment

## Task 3 - Reset the App Service to use the App Configuration and no longer directly reference the Key Vault

### Step 1 - Create the reset bicep
- update the settings for the App Service to use the App Configuration URL
### Step 2 - Add to the deployment  

### Step 3 - Deploy and Validate

>**Note**: the Application gets a 500.3 error.  This is because the code needs to be modified to leverage app Configuration.  We'll do that in the next Task.

## Task 4 - Modify the code to leverage the App Configuration

### Step 1 - Modify the code

### Step 2 - Deploy and Validate

## Completion

You have now completed the activities for this cloud workshop. We hope you enjoyed it and learned a lot during our training. Please feel free to reach out to us with any questions or feedback.  If you found any problems, please open issues on the repository. 

We'd love to hear from you!

