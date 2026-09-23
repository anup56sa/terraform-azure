resource "azurerm_resource_group" "rg" {
  name     = "rg-appservice-dev"
  location = "East US"
}

resource "azurerm_service_plan" "app_plan" {
  name                = "asp-appservice-dev"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  os_type  = "Linux"
  sku_name = "B1"
}

resource "azurerm_linux_web_app" "app" {
  name                = "appservice-dev-anup01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  service_plan_id = azurerm_service_plan.app_plan.id

  https_only = true

  site_config {
    always_on = true

    application_stack {
      node_version = "22-lts"
    }
  }

  app_settings = {
    ENVIRONMENT = "dev"
  }
}