just keeping this for now...


## Deploy the IAC

A number of resources are needed to complete this walkthrough, and can be deployed using the templates in the `iac` folder of this repository.

Deploy the IAC using the following instructions:  

- [Connect To Azure using the Azure CLI](https://learn.microsoft.com/cli/azure/authenticate-azure-cli?WT.mc_id=AZ-MVP-5004334)  
- [Get and change (set) your Azure subscription using the Azure CLI](https://learn.microsoft.com/cli/azure/manage-azure-subscriptions-azure-cli?WT.mc_id=AZ-MVP-5004334)  
- [Create a subscription deployment using the Azure CLI](https://learn.microsoft.com/azure/azure-resource-manager/bicep/deploy-to-subscription?WT.mc_id=AZ-MVP-5004334)  

```cli
deploymentName=protecting-secrets
loc=eastus
templateFile=deployall.bicep
az deployment sub create --name $deploymentName --location $loc --template-file $templateFile
```