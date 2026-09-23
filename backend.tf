terraform {
  backend "azurerm" {
    resource_group_name  = "anup-rg"
    storage_account_name = "terrastoreanup01"
    container_name       = "storestatefile"
    key                  = "appservice/main.tfstate"

    use_oidc             = true
    use_azuread_auth     = true
    tenant_id            = "fba9c407-61bd-49e5-b51a-9d8e7915e91f"
    client_id            = "723d093b-459c-4c71-a217-a6ce5e931b04"
  }
}