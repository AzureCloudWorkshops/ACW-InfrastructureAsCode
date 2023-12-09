# ACW-InfrastructureAsCode
This repository has Infrastructure As Code walkthroughs and challenges to teach the skills and concepts around automation of Azure Resources and deployments

## What you are building

In this walkthrough training, you will learn how to work with Infrastructure as Code (IaC) using bicep and/or Terraform.  By default, you will likely see a couple of ARM templates along the way as well.

In each module, you'll build a piece of the overall architecture, and you will learn some best practices and gotchas along the way.  By the end of this training, you will have a pretty solid understanding of how to work with IaC, and you will have a fully functional application running in Azure.  To get the application into Azure, you will use IaC for the overall resources and CI/CD with GitHub (or another similar tool) to deploy the application.

## Prerequisites

You will need the following prerequisites to complete this walkthrough:

- Visual Studio Code (IMHO, the best IDE for working with bicep and ARM templates, and possibly Terraform too).
- Visual Studio Community or better (or JetBrains Rider) to be able to run the ASP.NET Core Web application locally (this could be optional - you could likely do this with VS Code as well).
- .NET 6/7/8 SDK installed on your machine to develop .NET Core Web applications (for now the app is .NET 6, but will be upgraded to .NET 8 by the end of summer 2024 - feel free to upgrade to 8 at will, just make sure you have the SDK and that you can deploy to a .NET 8 app service in Azure).
- Microsoft SQL Server Developer Edition (or Express) installed on your machine.
- A GitHub Account (or other source control provider).
- An Azure Subscription (you can use a free trial if you don't have one).
- Basic Programming knowledge (ASP.Net MVC with C# is used in this walkthrough, but all the code changes are given to you so you don't really need to know how to develop solutions).
- GIT (required) with optional GIT command line tools (can use the IDE like VSCode, GitKraken, or Visual Studio instead if you desire)

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
1. Add a .gitignore file

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

#### Completion Check

Before proceeding, ensure that you can answer yes to the following questions:
- Do you have a remote repository with the code in place?
- Do you have a local repository with the code in place?
- Does the application run on your local machine and work as expected to register a user and perform CRUD operations around contacts?


## Introduction to IaC

The first module gives you an introduction to IaC.  You'll learn about how to work with Bicep or Terraform to create a simple resource group and storage account.  You'll also learn about thigns like:

- parameters
- variables
- outputs
- modules
- scopes

Complete the following module to learn about IaC and how to work with Bicep or Terraform.

- [Introduction to IaC](Part1-IntroductionToIaC.md)


## Completion Check

Before moving on, ensure that you have



![Resources](images/Part0-Prerequisites/image0001-resources.png)  



## Conclusion

In this walkthrough, you learned how to protect your secrets in your code, and how to use Azure App Configuration and Azure Key Vault to store and manage your secrets, and you examined a way to ensure that secrets are not accidentally published to GitHub or your application logs.
