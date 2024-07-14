variable "resourceGroupName" {
    type     = string
    nullable = false
}

variable "location" {
    type     = string
    nullable = false
}

variable "uniqueIdentifier" {
    type      = string
    nullable  = false
}

variable "webAppName" {
    type     = string
    nullable = false
}

variable "appConfigStoreName" {
    type     = string
    nullable = false
}

variable "identityDbSecretURI" {
    type     = string
    nullable = false
}

variable "managerDbSecretURI" {
    type     = string
    nullable = false
}

variable "keyVaultId" {
    type     = string
    nullable = false
}