variable "resourceGroupName" {
    type = string
    nullable = false
}

variable "location" {
    type = string
    nullable = false
    default = "East US"

    validation {
      condition = contains(["East US"], var.location)
      error_message = "Resources can only be deployed to East US location."
    }
}

variable "storageAccountName" {
    type = string
    nullable = false
    default = "cmstgacct"

    validation {
      condition = length(var.storageAccountName) > 3
      error_message = "The storage account name should be at least 3 characters"
    }
}

variable "uniqueIdentifier" {
    type = string
    nullable = false
    default = "20240109"

    validation {
      condition = length(var.uniqueIdentifier) == 11
      error_message = "The unique identifier should be 11 characters"
    }
}

variable "environment" {
    type = string
    nullable = false
    default = "dev"

    validation {
      condition = contains(["dev","prod"], var.environment)
      error_message = "The only valid values for environment are 'dev' and 'prod'"
    }
}

variable "containerName" {
    type = string
    nullable = false
}