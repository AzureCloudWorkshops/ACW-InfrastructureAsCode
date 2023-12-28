# Part 2- Building the Infrastructure

Part 2 of this workshop will teach you how to leverage permissions and GitHub actions to complete a fully automated IaC Pipeline in your azure subscription to host your web solution in an Azure App Service.


## Overall Goals of Part 2

In part 2 of this workshop, we're going to get the entire infrastructure deployed to host a web application in Azure. This will include the following resources:

- Resource Group
- App Service Plan
- App Service
    - settings/configurations
    - leverage KeyVault for secrets
    - managed identity
    - application Insights
    - log analytics workspace
- Key Vault
    - secret for database connection string
- Azure SQL Server
- Azure SQL Database
- Azure App Configuration (time permitting)

All of this will be done from GitHub Actions, not from the command line.  You can still test from the command line but the best solution will be to ensure that everything is working from GitHub Actions.

## Deployment Credentials

In order to deploy to the solution, you'll need to have the correct credentials in place on your subscription.  You will do this by creating a service principal and assigning it the correct permissions. 

You will then need to leverage the secrets from the service principal in GitHub Actions to deploy the infrastructure. (you will not be doing this part from the command line - but you can still deploy from the command line to test things as needed).  The end goal will be a full, working IAC pipeline that deploys the infrastructure.  

It will be incredibly important to manage the order of deployments for this infrastructure, because you need a Key Vault to have secrets, but you can't set the secret until you have the value for the connection string and the app service needs to have a principal that can connect to Key Vault and get the secrets.  All of this to say that when building your pipeline architecture, you have to do a lot of planning and you may need to do things in parts - i.e. deploy one resource, deploy a second resource, then come back to the first and update it with the second resource's information.

## Task 1 - Create a service principal

To get started, in order to deploy to Azure you will need to create a service principal/app registration.  This can be accomplished via the command line, however it is incredibly easy to do in the portal.  For that reason, this workshop will show how to do this in the portal in order to limit/minimize the number of problems that could result from doing it incorrectly via the command line.

1. Navigate to the Azure Portal and login with your credentials.

    Get logged in to the Azure portal.

1. Navigate to the App Registrations blade.

    Type `App Registrations` in the search bar and select the `App Registrations` blade.

    !["App Registrations"](images/Part2-common/image0000-AppRegistrations.png)  

1. Select `+ New Registration` at the top of the `App Registrations` blade.

    !["New Registration"](images/Part2-common/image0001-newregistration.png)  

1. Enter a name such as `iac-workshop-contactweb-dev` and select `Register`.

    Enter a name that makes sense for your service principal.  For this you are automating your IAC.  You would likely create one per environment (per subscription).  For this workshop, you can use `iac-workshop-contactweb-dev` as the name so you can remember what it is for.  For this workshop we will proceed as if all of this is being done in a development environment.  To add a production environment, you would repeat this process and create a new service principal for production, and you could leverage the same GitHub actions to deploy to production as a second task in just one overall pipeline.

    ```bash
    iac-workshop-contactweb-dev
    ```  

    Leave all of the other settings as their defaults - do not modify anything else on this screen.  Hit `Register` at the bottom of the screen.

    !["Register"](images/Part2-common/image0002-servicePrincipalAppRegistration.png)  

1. Gather the important id's for later use

    For GitHub Actions, you will need the following information from the overview screen:

    - Application (client) ID
    - Directory (tenant) ID

    Make sure to capture these somewhere so you can use them later.  Of course you can always come back here to get these values later if necessary.  

    !["Overview for App Registration"](images/Part2-common/image0003-applicationAndTenantIds.png)  

1. Create Federated Credentials

    To allow GitHub Actions to execute against this service principal, you will need to create federated credentials.

    Click on the `Certificates & secrets` blade on the left side of the screen.

    Then select `Federated credentials` at the middle of the screen.

    Then select `Add credential`.

    !["Federated Credentials"](images/Part2-common/image0004-creatingACredential.png)  

1. Create the scenario for GitHub Actions

    For the `Federeated credential scenario` select `GitHub Actions deploying Azure Resources`.

    For the Connect your GitHub account section, you will need to authorize your Azure Subscription and GitHub to talk to one another.

    Once you have done this, enter the organization name where your code for the contact web application is located.

    >**Note:** The organization is typically your github user account name (in the URL of your github account, the part right after `https://www.github.com/`).  For example, my repo is here: `https://github.com/blgorman/InfrastructureAsCodeACWWork`, so my organization name is `blgorman`. 

    Then enter the repository name where your code for the contact web application is located.  My repository is `InfrastructureAsCodeACWWork`.

    Select entity type: `Branch`  

    Then enter the branch name for deployment which is likely `main` or possibly `master`. My branch is `main`

    Then name the credential:

    ```bash
    iac-workshop-contactweb-dev-github-main
    ```  

    With description:
    
    ```bash
    GitHub Actions deploying Azure Resources
    ```

    Then select `Add`.
    
    !["Adding a credential"](images/Part2-common/image0005-branchdeploycredentials.png)  
            
1. Once the add is completed, you will see the credential in the list of federated credentials.

    !["Credential added"](images/Part2-common/image0006-federatedCredentialsMainBranch.png)

1. Additional credentials

    I like to add an environment credential that allows me to run the workflow from any branch.  Currently the only branch that can deploy is the `main` branch of my repo.  If you want to allow other branches to deploy, you will want a second federated credential that uses the `Environments` option.  This is also nice because it can ensure that only dev resources are deployed in the dev subscription.

    !["Dev environment federated credentials"](images/Part2-common/image0007-devEnvironmentFederatedCredential.png)  

    In the end, I have two. You need at least one (branch and/or environment) to deploy from GitHub Actions.

    !["Both federated credentials can coexist"](images/Part2-common/image0008-bothcredentialscreated.png)  


## Task 2 - Give the principal permissions to deploy

In order for the principal to deploy to Azure, it needs to have the correct permissions.  This is done via the `Access Control (IAM)` blade in the portal.

1. Navigate to the `Access Control (IAM)` blade for the subscription.

    If you are going to deploy a resource group in the subscription level, then you will need to be a contributor on the subscription.  This is done via the `Access Control (IAM)` blade in the portal for the subscription.

    Type `Subscriptions` in the search bar and select the `Subscriptions` blade. Then navigate to your subscription.

    !["Subscription Access Roles and Assignments"](images/Part2-common/image0009-subscriptionIAM.png)  

1. Select +Add then `Add role assignment` at the top of the `Access Control (IAM)` blade.

    !["Add role assignment"](images/Part2-common/image0010-addroleassignment.png)  

1. Add `Contributor`

    Select the `Privileged administrator roles` tab and then select `Contributor` from the list of roles.

    !["Contributor role"](images/Part2-common/image0011-contributorrole.png)  

1. Add `Members`

    Select `Members` -> leave the default of `User, group, or service principal` and hit the `+ Select members` button.

    Find the service principal you created in the previous task and select it.  Then hit `Select`.

    !["Members"](images/Part2-common/image0012-selectingtheprincipal.png)  

1. Hit `Review + assign`

    Validate that you have the correct principal and role and then hit `Review + assign`.

    !["Review and assign"](images/Part2-common/image0013-validateroleassignment.png)  

    Hit `Assign` to complete the assignment.

    Validate the role is shown in the `Role assignments` tab.

    !["Role Exists"](images/Part2-common/image0014-roleexists.png)  


## Task 2 - Set the GitHub Secrets

With the Azure credentials in place, it's time to get the GitHub Actions set up to log in and run deployments against your Azure subscription.

Once this is completed, you will be able to check in code changes and rely on the automation to run your templates (no longer needing to be logged in and run from your command line).  

1. Navigate to your GitHub repository

    Navigate to your GitHub repository where you have your code for the contact web application.

1. Select `Settings` at the top of the repository.

    !["Settings"](images/Part2-common/image0015-githubsettings.png)

1. Select `Secrets and variables`, then `Actions`, then hit the `New Repository secret` on the left side of the screen.

    !["Secrets and variables + Actions - new secret"](images/Part2-common/image0016-newsecret.png)  

1. Enter three secrets

    Secret one:  

    - Secret name: `AZURE_SUBSCRIPTION_ID`
    - Value: `<your azure subscription id>`  

    Secret two:

    - Secret name: `AZURE_CLIENT_ID_CONTACTWEB_DEV`
    - Value: `<your service client id>`    

    Secret three:

    - Secret name: `AZURE_TENANT_ID`
    - Value: `<your tenant id>`

    >**Note:** Your subscription ID can be easily obtained from almost any resource or by running the cli command `az account show` (field: `id`) If you run `az account show` you will also get your Tenant Id (field: `tenantId` not `homeTenantId` which could be different).  Your tenant and client id's can be obtained from the overview screen of your app registration in the portal and you likely copied them earlier in this workshop.  You can also get your subscription ID from the portal -> Subscriptions -> overview blade.

    !["Client ID"](images/Part2-common/image0017-clientid1.png)

    !["Client ID and Tenant ID"](images/Part2-common/image0018_clientId2tenantid.png)  

    !["Subscription ID"](images/Part2-common/image0019-SubscriptionId.png)  

1. Validate that you have the three secrets ready to go.

    You won't be able to see the values so if you have problems you may just need to come back here later and update the values in case something didn't copy/paste correctly.

    You can validate that the three secrets are in place, however:

    !["Repository Secrets"](images/Part2-common/image0020-reposecrets.png)  

## Completion check

Do not move forward until you have a service principal with the correct permissions to deploy to your subscription and you have the three secrets in place in your GitHub repository as you will not be able to complete the rest of this workshop/walkthrough without these in place.

## Task 3 - Create the automation action to execute the deployment

With everything in place to deploy, it's time to get the automation in place to execute the deployment.  This will be done via GitHub Actions.  Since the choice exists to do this with either bicep or terraform, this walkthrough will show how to do this with both.  The only part that will be different is the deployment action and the actual files used for deployment.  The rest of the workflow will generally be the same.

1. Navigate to the `Actions` tab of your repository and select `set up a workflow yourself`.

    !["Actions -> Set up a workflow yourself"](images/Part2-common/image0021-actionworkflow.png)  

1. Use the appropriate following yaml file for your deployment type.

    Bicep:  

```yaml
name: "Bicep Deploy Resources"

on:
  push:
    branches: [ main ]
  workflow_dispatch:

env: 
  CURRENT_BRANCH: ${{ github.head_ref || github.ref_name }} 
  AZURE_TENANT_ID:  ${{ secrets.AZURE_TENANT_ID }}
  AZURE_SUBSCRIPTION_ID: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
  AZURE_CLIENT_ID_CONTACTWEB_DEV: '${{ secrets.AZURE_CLIENT_ID_CONTACTWEB_DEV }}'
  TEMPLATE: 'iac/main.bicep'
  PARAMETERS: 'iac/main.parameters.json'  
  DEPLOYMENT_NAME: 'BicepDeployResources'
  REGION: 'eastus'
  
permissions:
  id-token: write
  contents: read

jobs:
  dev-deploy:
    name: Dev Deploy
    runs-on: ubuntu-latest
    environment:
      name: 'dev'

    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Log in to Azure
        uses: azure/login@v1.4.6
        with:
          client-id: ${{ env.AZURE_CLIENT_ID_CONTACTWEB_DEV }}
          tenant-id: ${{ env.AZURE_TENANT_ID }}
          subscription-id: ${{ env.AZURE_SUBSCRIPTION_ID }}

      - name: Deploy Resources
        uses: Azure/arm-deploy@v1.0.9
        with:
          scope: subscription
          subscriptionId: ${{ env.AZURE_SUBSCRIPTION_ID }}
          region: ${{ env.REGION }}
          template: '${{ env.TEMPLATE }}'
          parameters: '${{ env.PARAMETERS }}'
          deploymentName: '${{env.DEPLOYMENT_NAME}}-${{github.run_number}}'
          failOnStdErr: true
```

Terraform:  

```yaml

```

    >**Note:** You don't currently have a `main.bicep` or `main.tf` file so the first run should fail for bad file paths.  You will create these files in the next task.

1. Even though the run failed, validate login was successful

    Before moving forward, you should have a successful login in your workflow.  If that did not work, then you need to make sure the three secrets are correct and that you ran from the main branch or with the `dev` environment credential (both should have been the case - you were likely on your main branch and you put the `dev` environment variable in if you copied the code above).

    !["No file but login was successful"](images/Part2-common/image0022-loginsuccessjustneedfilebicep.png)  

1. Add appropriate infrastructure file(s) to your repo.

    For Bicep:  

    - Create a file called `main.bicep` in the `iac` folder of your repo.
    - Create a file called `main.parameters.json` in the `iac` folder of your repo.

    Add the following code to your `main.bicep` file (this should look really familiar, as it's just creating the resource group for now):

    ```bicep
    targetScope = 'subscription'

    param rgName string
    param location string

    resource iacTrainingResourceGroup 'Microsoft.Resources/resourceGroups@2018-05-01' = {
      name: rgName
      location: location
    }
    ```

    Add the following to your `main.parameters.json` file:

    ```json
    {
        "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
        "contentVersion": "1.0.0.0",
        "parameters": {
            "rgName": {
                "value": "iac-training-rg"
            },
            "location": {
                "value": "eastus"
            }
        }
    }
    ```  

    For Terraform:  

    - Create a file called `main.tf` in the `iac` folder of your repo.
    - Create a file called `main.tfvars` in the `iac` folder of your repo.

    Add the following code to your `main.tf` file (this should look really familiar, as it's just creating the resource group for now):

    ```terraform  
    ```  

    Add the following to your `main.tfvars` file:

    ```terraform  
    ```   

1. Check in your changes and ensure automation deployment completes successfully

    You should now see the deployment work as expected, and your action should run to completion and create/ensure the resource group exists as expected.

    !["Successful deployment"](images/Part2-common/image0023-deploysuccessful-bicep.png)  

1. Validate the run in the portal (optional)

    You can also see that the run completed in the portal as expected by going to the `Subscription` -> `Deployments` blade and looking for the deployment name you specified in the workflow.

    !["Deployment in the portal"](images/Part2-common/image0024-deploymentInThePortal.png)  

## Completion check

Do not move forward if you do not have a working IaC pipeline that executes a subscription-level deployment using your service principal credentials in your Azure subscription.  You should have a main file for deployment orchestration and it should ensure that the resource group exists in your subscription.  If you do not have this, you will not be able to complete the rest of this workshop/walkthrough.

## Breakouts

With the deployment pipeline in place, complete the following part(s) of the workshop that you would like to learn about:

1. Complete [Building the Infrastructure - Bicep](Part2-BuildingTheInfrastructure_bicep.md)

- or -

1. Complete [Building the Infrastructure - Terraform](Part2-BuildingTheInfrastructure_terraform.md)
