terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.33.0"
    }
  }
  backend "azurerm" {
    resource_group_name   = "mira"
    storage_account_name  = "ancient11"
    container_name        = "era"
    key                   = "dev.terraform.tfstate"
  }
}
provider "azurerm" {
  features {}
  subscription_id = "b37d1b55-e5e8-4acb-a848-fd89484f0997"


}





