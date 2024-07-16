# ACW-InfrastructureAsCode
This repository has Infrastructure As Code walkthroughs and challenges to teach the skills and concepts around automation of Azure Resources and deployments

## What you are building

In this walkthrough training, you will learn how to work with Infrastructure as Code (IaC) using bicep and/or Terraform.  By default, you will likely see a couple of ARM templates along the way as well.

In each module, you'll build a piece of the overall architecture, and you will learn some best practices and gotchas along the way.  By the end of this training, you will have a pretty solid understanding of how to work with IaC, and you will have a fully functional application running in Azure.  To get the application into Azure, you will use IaC for the overall resources and CI/CD with GitHub (or another similar tool) to deploy the application.

## Prerequisites

You will need the following prerequisites to complete this walkthrough:

- Visual Studio Code [v 1.85+](https://code.visualstudio.com/download) 
    - Bicep Extension
    - Terraform Extension
    - Azure Tools Extension
    - Optional: C# Extension
- A GitHub Account (or other source control provider like ADO/BitBucket, but we're focusing on GitHub) [GitHub](https://github.com/signup?).
- An Azure Subscription (you can use a free trial if you don't have one).
- Azure CLI [latest version, minimum 2.50+](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- Terraform [version 1.6.6+](https://developer.hashicorp.com/terraform/install?product_intent=terraform)
    - Windows: 
        ```text  
        choco install terraform
        ```  
    - Mac:  
        ```text  
        brew tap hashicorp/tap 
        brew install hashicorp/tap/terraform
        ```  
- GIT (required) with optional GIT command line tools [GIT](https://git-scm.com/downloads)
    - Could use a client like GitKraken or the tools in VSCode and/or Visual Studio
- Optional: Visual Studio Community or better (or JetBrains Rider) to be able to run the ASP.NET Core Web application locally (this could be optional - you could likely do this with VS Code as well). The code is complete and the extra pieces can be uncommented when the time is right, so you don't actually need to run the app locally if you don't want to. [Visual Studio Downloads](https://visualstudio.microsoft.com/downloads/)  
- Optional: .NET 6/7/8 SDK installed on your machine to develop .NET Core Web applications (for now the app is .NET 6, but will be upgraded to .NET 8 by the end of summer 2024 - feel free to upgrade to 8 at will, just make sure you have the SDK and that you can deploy to a .NET 8 app service in Azure). [Download .NET SDK](https://dotnet.microsoft.com/en-us/download/visual-studio-sdks)
- Optional: Microsoft SQL Server Developer Edition (or Express) installed on your machine [SQL Server](https://www.microsoft.com/en-us/sql-server/sql-server-downloads).
- Optional: SSMS (SQL Server Management Studio) installed on your machine [SSMS](https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver16).  
- Optional: - Basic Programming knowledge (ASP.Net MVC with C# is used in this walkthrough, but all the code changes are given to you so you don't really need to know how to develop solutions).

### Get the starter project into your GitHub repository

You will need a GitHub repository to store the code and this will be used to set up CI/CD to Azure via GitHub Actions.  If you want to use another repository like Azure DevOps, BitBucket, or GitLab, you can do that as well, but the instructions in this walkthrough will only show how to create GitHub actions for the IaC and CI/CD deployments.

If you get stuck, refer to the GitHub documents for:
- [How to create a repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-new-repository)  
- [How to clone a repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository)
- [How to fork a repository](https://docs.github.com/en/get-started/quickstart/fork-a-repo)

#### Steps

1. For simplicity, you can fork this repo: [https://github.com/AzureCloudWorkshops/ACW-InfrastructureAsCode_Workshop](https://github.com/AzureCloudWorkshops/ACW-InfrastructureAsCode_Workshop/blob/main/README.md).

Skip to the step "Open the project in Visual Studio" below.

OR:  

1. Create a local folder for your working directory, then initialize a repository in it.
1. Download the code from the '/src/StarterProject' folder of this repository.
1. Unzip the code into a folder at the root of your local repository.  
1. Add a .gitignore file if one is not included

    ```bash
    dotnet new gitignore
    ```  

1. Open the project in Visual Studio (or VS Code) 
1. Modify the connection string to a local db of your choice
1. Run two commands to update the database
    
    ```bash
    update-database -context ApplicationDbContext
    update-database -context MyContactManagerDbContext
    ```  
    
    >**Note**: This code-base uses two different database contexts - one for identity and one for business logic.  For this reason, you'll need to migrate both contexts to your local database, and at azure (they can both use the same connection string as the database can be shared, or you could have your identity in one database and the business logic in another).

1. Ensure that you can register a user and create a contact on your local machine.
1. Commit any changes and push the changes to your remote repository if you have any pending changes.  

You should now have a local repository with the code in place, and a remote repository with the code in place.

#### Completion Check

Before proceeding, ensure that you can answer yes to the following questions:
- Do you have a remote repository with the code in place?
- Do you have a local repository with the code in place?
- Does the application run on your local machine and work as expected to register a user and perform CRUD operations around contacts?

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
