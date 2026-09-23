terraform {
  backend "azurerm" {
    resource_group_name  = "anup-rg"
    storage_account_name = "terrastateanup01"
    container_name       = "storestatefile"
    key                  = "appservice/dev.tfstate"
  }
}