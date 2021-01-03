# Create a Resource Group
resource "azurerm_resource_group" "resource_group_dns" {
  name     = "dns-demo"
  location = "West Europe"
}

# Create a DNS zone
resource "azurerm_dns_zone" "domain" {
  name                = "domain.com"
  resource_group_name = azurerm_resource_group.resource_group_dns.name
}