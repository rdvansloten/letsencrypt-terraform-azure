# Create a Resource Group
resource "azurerm_resource_group" "resource_group_kv" {
  name     = "keyvault-demo"
  location = "West Europe"
}

# Create a Key Vault
resource "azurerm_key_vault" "key_vault" {
  name                            = "VAULT_NAME_HERE"
  location                        = azurerm_resource_group.resource_group_kv.location
  resource_group_name             = azurerm_resource_group.resource_group_kv.name
  sku_name                        = "standard"
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  soft_delete_enabled             = false
  enabled_for_disk_encryption     = true
  purge_protection_enabled        = false
  enabled_for_template_deployment = true
  enabled_for_deployment          = true
  soft_delete_retention_days      = 14

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "get",
      "list",
      "update",
      "create",
      "import",
      "delete",
      "recover",
      "backup",
      "restore"
    ]

    secret_permissions = [
      "get",
      "list",
      "set",
      "delete",
      "recover",
      "backup",
      "restore"
    ]

    storage_permissions = [
      "backup",
      "create",
      "delete",
      "deleteissuers",
      "get",
      "getissuers",
      "import",
      "list",
      "listissuers",
      "managecontacts",
      "manageissuers",
      "purge",
      "recover",
      "restore",
      "setissuers",
      "update"
    ]
  }

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }
}
