variable "resourceGroupName" {
    type     = string
    nullable = false
}

variable "location" {
    type     = string
    nullable = false
}

variable "appInsightsName" {
    type     = string
    nullable = false
}

variable "uniqueIdentifier" {
    type     = string
    nullable = false
}

variable "appServicePlanName" {
    type     = string
    nullable = false
}

variable "webAppName" {
    type     = string
    nullable = false
}

variable "defaultDBSecretURI" {
    type     = string
    nullable = false
}

variable "managerDBSecretURI" {
    type     = string
    nullable = false
}

variable "keyVaultId" {
    type     = string
    nullable = false
}