# Create a Resource Group
resource "azurerm_resource_group" "resource_group_kv" {
  name     = var.keyvault_rg
  location = var.region
}

# Create a Key Vault
resource "azurerm_key_vault" "vault" {
  name                            = var.key_Vault
  location                        = azurerm_resource_group.resource_group_kv.location
  resource_group_name             = azurerm_resource_group.resource_group_kv.name
  sku_name                        = "Standard"
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

    certificate_permissions = [
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
  }

  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }
}
