variable "resource_group" {
  description = "The resource group"
  default     = ""
}

variable "application_name" {
  description = "The name of your application"
  default     = ""
}

variable "environment" {
  description = "The environment (dev, test, prod...)"
  default     = "dev"
}

variable "location" {
  description = "The Azure region where all resources in this example should be created"
  default     = ""
}

variable "administrator_login" {
  description = "The SQL Server administrator login"
  default     = "sqladmin"
}
