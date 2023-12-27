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

## Task 2 - Set the GitHub Secrets

## Task 3 - Create the automation action to execute the deployment

## Completion check

Do not move forward if you do not have a working IaC pipeline that executes a subscription-level deployment using your service principal credentials in your Azure subscription.

## Breakouts

Complete the following part of the workshop that you would like to learn (or do both):

1. Complete [Building the Infrastructure - Bicep](Part2-BuildingTheInfrastructure_bicep.md)

- or -

1. Complete [Building the Infrastructure - Terraform](Part2-BuildingTheInfrastructure_terraform.md)
