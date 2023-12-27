# Part 1 - Introduction to IaC

In this first part, you will learn about Infrastructure as Code (IaC) and how to work with Bicep or Terraform to create a simple resource group and storage account.  You'll also learn about things like:
- running deployments from the command line
- running deployments from GitHub Actions
- building service principals with federated credentials

## Prerequisites

To complete this activity, you must have an editor like VSCode, an Azure Subscription with contributor access, and the Azure CLI installed, and you must also have installed the Azure bicep tools.

- [VSCode with bicep extension](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#visual-studio-code-and-bicep-extension)  
- [Azure CLI and Bicep tools](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#azure-cli)  

## Part 1: Introduction to IaC

To get started, let's dive in and create a simple resource group and storage account using Bicep.

## Task 1 - Create your first bicep file to deploy a storage account to an existing resource group

In order to create a deployment, a bicep file is needed. The overall goal for this activity is to create a resource group and a storage account.  We'll do this in two steps by creating a new bicep file. During this first deployment, we will use a resource-group level deployment.  First, we'll use the Azure CLI to create a resource group in our subscription, then we'll create a storage account. As we're going, you'll learn about using parameters, variables, and outputs, as well as how to create and use separate files as modules.

>**Note:** for this activity, I'm using VSCode with the Bicep extension.  Additionally, I've created a new repository at GitHub which has the starter web application code in it and will be where I'm generating screenshots.  For this reason, if you haven't already, you will want to have a GitHub repository where you can store your code and your bicep files (if you forked this repo you can leverage this repo but if you want it to be cleaner I would recommend your own repository with the source code only).

A good way to store your resources would be similar to the following:

!["Initial repo with folder structure"](images/Part1-bicep/image0001-initialrepo.png)  

### Step 1 - Create your file `storageAccount.bicep`

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

### Completion Check

Before moving on, ensure that you have a file called `storageAccount.bicep` in a folder called `iac` at the root of your repository.

!["The file resourceGroup.bicep along with the commands to create in bash"](images/Part1-bicep/image0002-creatingTheBicepFile.png)  

### Step 2 - Create the bicep for a storage account

For this first activity, you'll be creating a simple storage account.  To do this easily, you'll want a couple of extensions for Bicep in place in VSCode:

- Bicep: 
!["The VSCode Bicep Extension is shown"](images/Part1-bicep/image0003-bicepExtension.png)  

- Azure Tools: 
!["The VSCode Azure Tools Extension is shown"](images/Part1-bicep/image0004-azuretools.png)

>**Note:** We may not need Azure Tools, but it's a good idea to have it in place for other things you will do in the future.


...WIP..

## Task 2 - Create a resource group

You can create a resource group in the portal or via command line commands with the azure CLI. If you are struggling with the CLI, just pivot and go create a resource group in the portal (or switch to run the commands in the Azure Cloud Shell rather than from your local machine).

Assuming that creating a resource group is straight forward in the portal, let's do it via the CLI.

### Step 1 - Get Logged in

...WIP...

>**Note:** If you are using the Azure Cloud Shell, you can skip to step 3 and just use the cloud shell.

### Step 2 - Ensure your subscription

...WIP...

### Step 3 - Create the resource group via CLI commands

...WIP...

### Completion Check

You have a resource group named as you intended in your Azure subscription in the region of your choice.

## Task 3 - Run the deployment

...WIP...

### Step 1 - Issue commands to run the deployment

### Step 2 - Verify the deployment

### Completion Check

You have a storage account in your resource group that was named as you intended.

## Task 4 - Use parameters

In this part you'll create parameters for the storage account name and location.  You'll also learn how to use the parameters in your deployment.

### Step 1 - Add parameters to the bicep file

### Step 2 - Create a parameters file

### Step 3 - Deploy via parameters file

### Completion Check

You have a file that you can reuse in multiple resource groups with various storage account names

## Task 5 - Use variables and functions

In this module you will learn to use variables and functions to create a unique string name for the storage account name

### Step 1 - Create a variable for the storage account name

### Step 2 - Use the variable in the storage account name

### Step 3 - Add a unique string to the storage account name

### Step 4 - Deploy via parameters file

### Completion Check

You can now deploy the same file to different resource groups multiple times and it will create a unique storage account name per group

## Task 6 - Use modules and outputs

In part 2, we will be doing an entire subscription deployment.  For that reason, let's learn about it quickly here before diving deeper in part 2.

### Step 1 - Create an orchestrator file

Use subscription level

### Step 2 - Create a module for the storage account

call the storage deployment at the subscription scope for the correct resource group

### Step 3 - Create an output for the storage account 

Examine the output of the deployment in the portal

### Step 4 - Show how to leverage an output in another deployment

Add another file to create a container in the storage account
Deploy via a module
Explain that this could easily be done in one file.  The reason for doing it this way is to show how to use outputs in other deployments.

### Step 4 - Deploy via cli

Deploy the subscription level deployment to Azure

## Conclusion

In this first part, you learned how to work with Bicep to create a simple storage account in a resource group.  You also learned about things like:
- creating bicep files
- running deployments from the command line
- using parameters
- using variables
- using functions
- using modules
- using outputs


