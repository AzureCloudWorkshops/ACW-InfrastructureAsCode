variable "storageAccountNameEnv" {
    type = string
    nullable = false
}

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