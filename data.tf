# Get Resource Group that holds the DNS records
data "azurerm_resource_group" "dns_records" {
  name = "RESOURCE_GROUP_NAME"
}