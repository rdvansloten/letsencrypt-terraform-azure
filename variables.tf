variable "certificates" {
  type = any
}

variable region {
  description = "Region to create resources in."
  type        = string
  default     = "West Europe"
}

variable "keyvault_name" {
  description = "Name of your Key Vault. Must be unique worldwide."
  type        = string
}

variable "keyvault_rg" {
  description = "Name of your Key Vault. Must be unique worldwide."
  type        = string
}

variable "dns_zone_rg" {
  description = "Resource Group where your DNS zone resides."
  type        = string
}

variable "contact_email" {
  description = "Email address for renewal notifications."
  type        = string
}