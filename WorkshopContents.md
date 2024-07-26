# Workshop: Infrastructure as Code

This is the general road map for the Infrastructure as Code Workshop.

## Step 0: Pre-requisites

In order to complete the workshop, you'll need to have your machine and accounts set up.  Please make sure to complete the pre-requisites before the day of the workshop to make sure that you are ready to work with your account at Azure from your local machine and have your GitHub repository ready to go.

- [Pre-requisites (in the README)](README.md)

## Step 1: Introduction to IaC

The first module gives you an introduction to IaC.  You'll learn about how to work with Bicep or Terraform to create a simple resource group and storage account.  You'll also learn about things like:

- parameters
- variables
- outputs
- modules
- scopes

Complete the introductory module then choose one or both of the submodules for Bicep and/or Terraform to learn about IaC and how to work with Bicep or Terraform.  

- [Part 1 - Introduction to IaC](Part1-IntroductionToIaC.md)

## Completion Check

Before moving on, ensure that you have a full understanding of how to create a deployment using Bicep or Terraform.  You should be able to answer the following questions:
- How do you work with parameters and variables?
- Which type can be passed in from the command line/template file?
- What is the purpose of outputs?
- What is the purpose of modules? How do you utilize a module?
- What is the purpose of scopes?  When would you use a scope? When would a scope be implicit?

## Step 2: Build the infrastructure

In this step you will build the IaC that will provision the entire environment for the application.

Complete the introductory module then choose one or both of the submodules for Bicep and/or Terraform to learn about IaC and how to work with Bicep or Terraform.  

- [Part 2 - Building the Infrastructure](Part2-BuildingTheInfrastructure.md)

### Overall Architecture

It will be helpful to remember the overall architecture for build order and dependencies. This diagram can be used to visualize the final solution.

!["Overall Architecture"](/images/ContactWeb.drawio.png)  

### Completion Check

The following resources are needed to complete this walkthrough:
- Resource Group
- Log Analytics Workspace
- Application Insights
- App Service Plan
- App Service
- Azure SQL Server
- Key Vault

## Step 3: Build CI/CD to deploy the application

In this step you will build out the CI/CD pipeline to deploy the application to Azure.  You will use GitHub Actions to build the pipeline (or another pipeline/action from another source control provider).  This part will be the same regardless of which architecture you choose to use for the IaC. 

- [Part 3 - Implementing the CI/CD](Part3-ImplementingCICD.md)

### Completion Check

At the end of this step, you have a working deployment for any code changes, which deploy the application to your Azure environment.

## Step 4: Azure App Configuration

If there is enough remaining time, adding the Azure App Configuration to share resources is a great way to continue to learn.  This step will only require additional changes to existing deployments, so there is no common step, just pick the one that you want to work with and complete the activity

Complete one of the following: 

- [Part 4 - Azure App Configuration - Bicep](Part4-AzureAppConfiguration_bicep.md)  

- or - 

- [Part 4 - Azure App Configuration - Terraform](Part4-AzureAppConfiguration_terraform.md)  

### Completion Check

At the end of this step, you have added Azure App Configuration and reconfigured the code to leverage the configuration instead of the KeyVault.  

In addition to the resources in part 2, you should have the following resources:
- Azure App Configuration

## Conclusion

In this walkthrough, you learned how to work with IaC using Bicep and/or Terraform.  You then learned how to automate the deployment of your IaC pipeline to ensure your architecture is built consistently at Azure.

You completed the circle by learning how to build a CI/CD pipeline to deploy the application to Azure.  

You should now feel confident that you have the understanding and skills to build out IaC and CI/CD pipelines for your own applications.
