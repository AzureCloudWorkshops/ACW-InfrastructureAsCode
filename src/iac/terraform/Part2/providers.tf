terraform {
  required_version = ">=1.6.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"      
    }
    arm2tf = {
      source  = "cloud-maker-ai/arm2tf"
      version = "0.2.2"
    }    
  }

  backend "azurerm" {
    resource_group_name  = "rg-terraform-github-actions-state"
    storage_account_name = "tfghactions20241231sam"
    container_name       = "tfstatepart2"
    key                  = "terraform.tfstate"
    use_oidc             = true
  }
}

provider "azurerm" {
  features {    
  }
  use_oidc = true
}