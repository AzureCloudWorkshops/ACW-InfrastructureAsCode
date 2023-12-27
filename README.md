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
- Terraform [version 1.6.6](https://developer.hashicorp.com/terraform/install?product_intent=terraform)
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

1. Create a local folder for your working directory, then initialize a repository in it - [or fork this repo, clone it to your working directory and skip to step 4]
1. If you didn't fork, download the code from the '/src/StarterProject' folder of this repository.
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

## Step 0: Basics of Azure deployment, RBAC, and Policy scopes

Before getting started, it's important to note that there are scopes for executing deployments at Azure.  The following scopes are available:
- management group
- subscription
- resource group

### Management Groups

Management groups can have multiple subscriptions, so they are the top-level scope.  Anything done at the management group level can 'trickle-down' to the subscriptions and resource groups below it.  For example, if you assign a policy at the management group level, it will apply to all subscriptions and resource groups below it. If you create the policy at the management group but don't apply it, it will not apply to the subscriptions and resource groups below it unless they directly implement the policy.

Only some resources make sense to deploy at this level.  For example, you typically deploy policies at this level.  You may also deploy things like Azure Monitor Workspaces, Azure Security Center, etc.  You would not deploy things like storage accounts, virtual machines, etc. at this level, as those are typically scoped to a subscription in a resource group.

Management groups can be nested within other management groups as well. For example, you may have a management group for your entire organization, and then you may have management groups for each department, and then you may have management groups for each team within the department.  This is a good way to organize your resources and deployments, but it is not required, and this is typically not done unless you have a large organization with many teams and/or departments.

### Subscriptions

Subscriptions are the next level down from management groups.  Subscriptions are an excellent barrier for RBAC, policy, and billing so at this level, resources are typically mapped to environments and/or clients.  You can have multiple subscriptions under a single management group.  You can also have multiple resource groups under a subscription.  For example, common solutions for a single organization may be to have a subscription for each environment (dev, prod).  If your company has multiple clients, you may have a subscription for each client, and you many even have multiple subscriptions for each client (for the client dev, prod, etc).

### Resource Groups

Resource groups are a barrier for resources that are typically grouped together for lifecycle and/or security purposes. Resource groups are really for us humans that can't keep things straight in our heads over multiple workloads.  Azure will allow you to group in resource groups but that does not limit you to what can be deployed or to which region the resources can be deployed.  For example, you can deploy a storage account in a resource group in the East US region and a virtual machine in the same resource group in the West US region.  This is not recommended, but it is possible.  Typically, it would be recommended to separate workloads such as your web application with it's database, virtual machines, keyvaults, etc into groups that make sense both from a security and lifecycle perspective.  

For example, RBAC controls can let a client view resources only in one single resource group where your team might need to see all of the groups (subscription-level permissions).  

All resources live in resource groups, so it will be up to your team on how you want to deploy them.

### Why is this important?  

The reason this is important is because you can run deployments that only target a single resource group or you can run a deployment that targets the subscription and can therefore span multiple resource groups.

For example, suppose you just need a single storage account.  You can do that deployment to a single resource group.  Your IAC principal then only needs permission to that resource group (we'll do this in the first activity).

However, in real deployments for your company, you'll likely see a deployment that spans your entire subscription.  For example, you may have a deployment that creates a resource group for your web application and its resources, a resource group for your KeyVault used to encrypt storage and database keys, and in more robust scenarios you may also need to deploy networks and resources related to the networking. In these cases, you'll need to have permissions to the entire subscription, and you will likely create an orchestrator file (just a bicep or terraform file that calls other bicep or terraform files) that will deploy all of the resources with one deployment operation calling to modules. We will do this in part two when we deploy the entire application in part 2.

## Step 1: Introduction to IaC

The first module gives you an introduction to IaC.  You'll learn about how to work with Bicep or Terraform to create a simple resource group and storage account.  You'll also learn about things like:

- parameters
- variables
- outputs
- modules
- scopes

Complete one or both of the following modules to learn about IaC and how to work with Bicep or Terraform.

- [Introduction to IaC - Bicep](Part1-IntroductionToIaC_bicep.md)
- [Introduction to IaC - Terraform](Part1-IntroductionToIaC_terraform.md)

## Completion Check

Before moving on, ensure that you have a full understanding of how to create a deployment using Bicep or Terraform.  You should be able to answer the following questions:
- How do you work with parameters and variables?
- Which type can be passed in from the command line/template file?
- What is the purpose of outputs?
- What is the purpose of modules? How do you utilize a module?
- What is the purpose of scopes?  When would you use a scope? When would a scope be implicit?

## Step 2: Build the infrastructure

In this step you will build the IaC that will provision the entire environment for the application.

Complete one or both of the following modules to learn about IaC and how to work with Bicep or Terraform.

- [Introduction to IaC - Bicep](Part2-BuildingTheInfrastructure_bicep.md)
- [Introduction to IaC - Terraform](Part2-BuildingTheInfrastructure_terraform.md)

### Completion Check

The following resources are needed to complete this walkthrough:
- Resource Group
- Log Analytics Workspace
- Application Insights
- App Service Plan
- App Service
- Azure SQL Server
- Key Vault
- Azure App Configuration [time permitting]

## Step 3: Build CI/CD to deploy the application

In this step you will build out the CI/CD pipeline to deploy the application to Azure.  You will use GitHub Actions to build the pipeline (or another pipeline/action from another source control provider).

Complete one or both of the following modules to learn about IaC and how to deploy with GitHub.

- [Part 3 - Implementing the CI/CD](Part3-ImplementingCICD.md)

### Completion Check

At the end of this step, you have a working deployment for any code changes, which deploy the application to your Azure environment.

## Conclusion

In this walkthrough, you learned how to protect your secrets in your code, and how to use Azure App Configuration and Azure Key Vault to store and manage your secrets, and you examined a way to ensure that secrets are not accidentally published to GitHub or your application logs.
