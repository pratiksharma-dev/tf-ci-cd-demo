terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.42"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

locals {
  // If an environment is set up (dev, test, prod...), it is used in the application name
  environment      = var.environment == "" ? "dev" : var.environment
  application_name = var.environment == "" ? var.application_name : "${var.application_name}-${local.environment}"
  resource_group   = "rg-${local.application_name}-001"
}

resource "azurerm_resource_group" "main" {
  name     = local.resource_group
  location = var.location

  tags = {
    "terraform"   = "true"
    "environment" = local.environment
  }
}

module "application" {
  source            = "./modules/app-service"
  resource_group    = local.resource_group
  application_name  = local.application_name
  environment       = local.environment
  location          = var.location

  database_url      = module.database.database_url
  database_username = module.database.database_username
  database_password = module.database.database_password

  depends_on = [
    module.database,
    azurerm_resource_group.main
  ]
}

module "database" {
  source           = "./modules/sql-server"
  resource_group   = local.resource_group
  application_name = local.application_name
  environment      = local.environment
  location         = var.location

  depends_on = [
    azurerm_resource_group.main
  ]
}
