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
}

provider "azurerm" {
  features {    
  }
}