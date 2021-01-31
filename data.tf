# Get Resource Group that holds the DNS records
data "azurerm_resource_group" "dns_records" {
  name = var.dns_zone_rg
}

# Get current Azure context
data "azurerm_client_config" "current" {
}