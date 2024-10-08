terraform {

  required_version = "1.5.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.3.0"
    }
  }
}

provider "azurerm" {
  features {}
}
