# Azure App Configuration

Welcome to the bonus track! If you made it this far, that's great! You are now ready to learn about Azure App Configuration. This is a service that allows you to store your application settings and feature flags in a central place. It is a great way to decouple your application from its configuration data. It also provides a way to manage the configurations without having to redeploy your application.  Another great use for the App Configuration is for sharing configurations between multiple applications.  

In this section, you will learn how to create an App Configuration instance and how to use it in your application.  You will then reset the configuration values from the App Service to leverage the App Configuration instead of the Key Vault directly (don't worry, the Key Vault is still used to store the secrets).  You will also need to make a small code change so that the application can leverage the App Configuration.  

## Part 1 - Create an App Configuration instance

- App configuration with Identity
- Permission to get secrets from Key vault
- Two KeyVault references to the Key Vault secrets


## Part 2 - Modify the code and leverage the App Configuration

