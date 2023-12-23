# Part 1 - Introduction to IaC

In this first part, you will learn about Infrastructure as Code (IaC) and how to work with Bicep or Terraform to create a simple resource group and storage account.  You'll also learn about things like:
- running deployments from the command line
- running deployments from GitHub Actions
- building service principals with federated credentials

## Prerequisites

To complete this activity, you must have an editor like VSCode, an Azure Subscription with contributor access, and the Azure CLI installed.

## Part 1: Introduction to IaC

To get started, let's dive in and create a simple resource group and storage account using Bicep.

Before getting started, it's important to note that there are scopes for executing deployments.  The following scopes are available:
- management group
- subscription
- resource group

### Management Groups

Management groups span subscriptions.  Anything done at this level can 'trickle-down' to the subscriptions and resource groups below it.  For example, if you assign a policy at the management group level, it will apply to all subscriptions and resource groups below it. If you create the policy at the management group but don't apply it, it will not apply to the subscriptions and resource groups below it unless they directly implement the policy.

Only some resources make sense to deploy at this level.  For example, you typically deploy policies at this level.  You may also deploy things like Azure Monitor Workspaces, Azure Security Center, etc.  You would not deploy things like storage accounts, virtual machines, etc. at this level, as those are typically scoped to a subscription in a resource group.

### Subscriptions

Subscriptions are the next level down from management groups.  Subscriptions are an excellent barrier for RBAC and resources that typically are mapped to environments and/or clients.  They are also the billing boundary for Azure.  You can have multiple subscriptions under a management group.  You can also have multiple resource groups under a subscription.  For example, common solutions for a single organization may be to have a subscription for each environment (dev, prod).  If your company has multiple clients, you may have a subscription for each client, and you many even have multiple subscriptions for each client (dev, prod).

### Resource Groups

Resource groups are a barrier for resources that are typically grouped together for lifecycle and/or security purposes. Resource groups are really for us humans that can't keep things straight in our heads over multiple workloads.  Azure will allow you to group in resource groups but that does not limit you to what can be deployed or to which region the resources can be deployed.  For example, you can deploy a storage account in a resource group in the East US region and a virtual machine in the same resource group in the West US region.  This is not recommended, but it is possible.  Typically, it would be recommended to separate workloads such as your web application with it's database, virtual machines, keyvaults, etc into groups that make sense both from a security and lifecycle perspective.  

For example, RBAC controls can let a client view resources only in one single resource group where your team might need to see all of the groups (subscription-level permissions).  

All resources live in resource groups, so it will be up to your team on how you want to deploy them.

### Why is this important?  

The reason this is important is because you can run deployments that only target a single resource group or you can run a deployment via IAC that targets the subscription and can span multiple resource groups.

For example, suppose you just need a single storage account.  You can do that deployment to a single resource group.  Your IAC principal then only needs permission to that resource group (we'll do this in the first activity).

However, in real deployments for your company, you'll likely see a deployment that spans your entire subscription.  For example, you may have a deployment that creates a resource group for your web application, a resource group for your database, a resource group for your keyvault, and in more robust scenarios you'll also need to deploy networks and resources related to the networking. In this case, you'll need to have permissions to the entire subscription, and you will likely create an orchestrator file (just a bicep file that calls other bicep files) that will deploy all of the resources. We will do this in part two when we deploy the entire application.

## Task 1 - Create your first bicep file to deploy a storage account to an existing resource group

To get started, let's create our first bicep file. The overall goal for this activity is to create a resource group and a storage account.  We'll do this in two steps.  First, we'll create a resource group, then we'll create a storage account. As we're going, you'll learn about using parameters, variables, and outputs, as well as how to create and use separate files as modules.

>**Note:** for this activity, I'm using VSCode with the Bicep extension.  Additionally, I've created a new repository at GitHub which has the starter web application code in it and will be where I'm generating screenshots.  For this reason, if you haven't already, you need a GitHub repository where you can store your code and your bicep files.

A good way to store this would be similar to the following:

!["Initial repo with folder structure"](images/Part1-bicep/image0001-initialrepo.png)  

###3 Step 1 - Create your file `storageAccount.bicep`

For bicep, the file you create is a simple file that ends with the *.bicep extension. This can be done in a bash terminal, in VSCode, or in PowerShell. Assuming you can make your way to the correct place and/or make your way to VSCode, create a folder if you don't have one for `iac`.  In that folder, create a file `storageAccount.bicep`.

Folder:  

```bash  
iac
```  

FileName:

```bash  
storageAccount.bicep
```  

VSCode:  

```text  
Right-click on the folder and select New File, name it `storageAccount.bicep`
```  

>**Note**: For bash and powershell, make sure you make directories `mkdir` and change directories `cd` to the correct location.

Bash:  

```bash  
touch storageAccount.bicep
```  

PowerShell:  

```PowerShell
"" > "storageAccount.bicep"
```  

#### Completion Check

Before moving on, ensure that you have a file called `storageAccount.bicep` in a folder called `iac` at the root of your repository.

!["The file resourceGroup.bicep along with the commands to create in bash"](images/Part1-bicep/image0002-creatingTheBicepFile.png)  

### Step 2 - Create the bicep for a storage account

For this first activity, you'll be creating a simple storage account.  To do this easily, you'll want a couple of extensions for Bicep in place in VSCode:

- Bicep: 
!["The VSCode Bicep Extension is shown"](images/Part1-bicep/image0003-bicepExtension.png)  

- Azure Tools: 
!["The VSCode Azure Tools Extension is shown"](images/Part1-bicep/image0004-azuretools.png)

>**Note:** We may not need Azure Tools, but it's a good idea to have it in place for other things you will do in the future.