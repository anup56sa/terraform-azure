resource "azurerm_resource_group" "rg" {
  name     = "rg-keyvault-dev"
  location = "Central US"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-keyvault-dev"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "private_endpoint" {
  name                 = "snet-private-endpoint"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name

  address_prefixes = ["10.0.1.0/24"]

  private_endpoint_network_policies = "Disabled"
}

resource "azurerm_key_vault" "kv" {
  name                = "kv-anup-dev-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = "fba9c407-61bd-49e5-b51a-9d8e7915e91f"

  sku_name = "standard"

  public_network_access_enabled = false

  purge_protection_enabled   = false
  soft_delete_retention_days = 7

  rbac_authorization_enabled = true
}

resource "azurerm_private_dns_zone" "keyvault" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_endpoint" "kv" {
  name                = "pe-keyvault-dev"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.private_endpoint.id

  private_service_connection {
    name                           = "psc-keyvault"
    private_connection_resource_id = azurerm_key_vault.kv.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "default"

    private_dns_zone_ids = [
      azurerm_private_dns_zone.keyvault.id
    ]
  }
}

