variable "resource_group_name" {
    type = string
    nullable = false
}

variable "location" {
    type = string
    nullable = false
}

variable "sqlServerName" {
    type     = string
    nullable = false
}

variable "sqlServerAdmin" {
    type     = string
    nullable = false
}

variable "sqlServerPwd" {
    type      = string
    nullable  = false
    sensitive = true
}

variable "sqlDatabaseName" {
    type     = string
    nullable = false
}

variable "uniqueIdentifier" {
    type     = string
    nullable = false
}

variable "clientIpAddress" {
    type     = string
    nullable = false
}

variable "sqlDbSkuName" {
    type     = string
    nullable = false

    validation {
      condition     = contains(["Basic"], var.sqlDbSkuName)
      error_message = "Only SKU allowed for DB is 'Basic'"
    }
}

variable "logAnalyticsWorkSpaceName" {
    type = string
    nullable = false
}

variable "appInsightsName" {
    type     = string
    nullable = false
}

variable "keyVaultName" {
    type      = string
    nullable  = false
}

variable "appServicePlanName" {
    type     = string
    nullable = false
}

variable "webAppName" {
    type     = string
    nullable = false
}

variable "appConfigStoreName" {
    type     = string
    nullable = false
}