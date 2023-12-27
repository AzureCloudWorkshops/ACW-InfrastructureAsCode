# Part 1: Introduction to IaC 

In this first part of the training walk through, you will have some common tasks to complete, then you will be able to choose if you want to complete the training with Bicep or Terraform (or both). 

First, let's take a minute to get familiar with Azure and how to work with various scopes for management and deployment. 

## Basics of Azure deployment, RBAC, and Policy scopes

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

## Task 1: Get Logged in to Azure from the CLI

In this first task, you will log in to Azure from the CLI.  This will allow you to run commands against your subscription.  You will need to have an Azure subscription to complete this task.  If you don't have an Azure subscription, you can create a free account [here](https://azure.microsoft.com/en-us/free/).  You will also need to make sure you have the Azure CLI installed.  You can find instructions on how to install the Azure CLI [here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).

### Step 1 - Get Logged in

To get started, you will need to have a terminal open to run the azure cli.  You can do this in Visual Studio Code terminal for Bash or PowerShell, or really any other terminal as long as you can run commands (even the windows command line should work).

Begin by making sure you can run the Azure CLI.  You can do this by running the following command:

```bash
az --version
```  

!["Checking the Azure CLI version"](images/Part1-common/image0001-azversion.png)


```text  
Enter the command az login
```

!["Logging into Azure"](images/Part1-terraform/azurelogin.png)  

A browser window will open, enter login credentials or select an account that you are already logged in to.

!["Selecting an account in the browser"](images/Part1-terraform/azureloginselect.png)  

A confirmation window will appear.

!["Login confirmation"](images/Part1-terraform/azureloginconfirmation.png)  

>**Note:** If you are using the Azure Cloud Shell, you can skip to step 3 and just use the cloud shell.

### Step 2 - Ensure your subscription



>**Note:** If you are having trouble getting logged in from your local machine, you can use the Azure Cloud Shell to complete the work in this training.  You can find instructions on how to use the Azure Cloud Shell [here](https://docs.microsoft.com/en-us/azure/cloud-shell/overview).  You will need to use the shell and run the commands as shown in these walkthroughs, but you will need to also ensure you have the files for your deployments created in the shell as well if you go this route.  Using the azure cloud shell will not be shown in the walkthroughs, so if you go this route you will need to figure out how to create the files in the shell and run the commands as shown in the walkthroughs.

## Task 2 - Create a resource group

In this second task, you'll use the Azure CLI to create a resource group.  You'll need to have an Azure subscription and you'll need to be logged in to Azure from the CLI.  If you haven't completed the first task, please do so before continuing.  

You can create a resource group in the portal or via command line commands with the azure CLI. If you are struggling with the CLI, just pivot and go create a resource group in the portal (or switch to run the commands in the Azure Cloud Shell rather than from your local machine).

Assuming that creating a resource group is straight forward in the portal, let's do it via the CLI for the purposes of learning.




## Task N: Complete the IaC activity with Bicep or Terraform

Choose your path and complete the work using the tool of your choice.  You can do both if you want to, but you only need to do one to complete the training.

[Part 1 - Introduction to IaC - Bicep](Part1_IntroductionToIaC_bicep.md)  

[Part 1 - Introduction to IaC - Terraform](Part1_IntroductionToIaC_terraform.md)  
