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

1. Get the object ID for the group

    You will use this as a parameter to your IaC.  In reality you could also have done all of this with the CLI or via other bicep files.  However, let's draw the line since this is pretty much a one-time thing per tenant/subscription.

### Step 2 - Modify the Key Vault Bicep

In this step you'll modify the key vault bicep to create the user managed identity, and add the group and user managed identity to the permissions.

1. Modify Bicep

1. Modify Parmeters

1. Modify the main deployment

1. Deploy the changes & validate

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

