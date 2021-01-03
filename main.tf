# Generate a private key for LetsEncrypt account
resource "tls_private_key" "reg_private_key" {
  algorithm = "RSA"
}

# Create an LetsEncrypt registration
resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.reg_private_key.private_key_pem
  email_address   = var.contact_email
}

# Generate a private key per certificate
resource "tls_private_key" "cert_private_key" {
  for_each  = var.certificates
  algorithm = each.value.key_type
}

# Generate LetsEncrypt certificates using Azure DNS
resource "acme_certificate" "certificate" {
  for_each                  = var.certificates
  common_name               = each.key
  subject_alternative_names = each.value.subject_alternative_names
  key_type                  = each.value.key_size
  account_key_pem           = acme_registration.reg.account_key_pem
  min_days_remaining        = 60 # Won't request new certificate until current certificate is > 29 days old

  dns_challenge {
    provider = "azure"
    config = {
      AZURE_POLLING_INTERVAL    = 30
      AZURE_PROPAGATION_TIMEOUT = 600
      AZURE_TTL                 = 30
      AZURE_RESOURCE_GROUP      = data.azurerm_resource_group.dns_records.name
      AZURE_SUBSCRIPTION_ID     = data.azurerm_client_config.current.subscription_id
      AZURE_TENANT_ID           = data.azurerm_client_config.current.tenant_id
    }
  }
}

# Create .pfx file locally
resource "local_file" "pfx_certificates" {
  for_each       = var.certificates
  content_base64 = acme_certificate.certificate[each.key].certificate_p12
  filename       = "${replace(replace(each.key, "*", "wildcard"), ".", "-")}.pfx" # Transforms CN to valid string
}

# Import certificates to Azure Key Vault. 
# IMPORTANT: Does not update certificates if Purge Protection is ON! See workaround below.
resource "azurerm_key_vault_certificate" "certificate" {
  for_each     = var.certificates
  name         = replace(replace(each.key, "*", "wildcard"), ".", "-") # Transforms CN to valid string
  key_vault_id = data.azurerm_key_vault.vault.id

  certificate {
    contents = acme_certificate.certificate[each.key].certificate_p12
    password = "PASSWORD"
  }

  certificate_policy {
    issuer_parameters {
      name = "Unknown"
    }

    key_properties {
      exportable = true
      reuse_key  = true
      key_size   = each.value.key_size
      key_type   = each.value.key_type
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }
  }
}

/*
# Import certificate into Azure Key Vault if purge protection and soft delete are enabled
resource "null_resource" "az_keyvault_upload" {
  for_each = var.certificates
  triggers = {
    triggerme = acme_certificate.certificate[each.key].certificate_p12
  }
  provisioner "local-exec" {
    command = "az keyvault certificate import --vault-name ${data.azurerm_key_vault.vault.name} -n ${replace(replace(each.key, "*", "wildcard"), ".", "-")} -f ${replace(replace(each.key, "*", "wildcard"), ".", "-")}.pfx"
  }
}
*/