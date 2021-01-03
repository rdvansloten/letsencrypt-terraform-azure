certificates = {
  "*.domain.com" = {
    key_type                  = "RSA"
    key_size                  = 4096
    subject_alternative_names = ["domain.com"]
  },
  "subdomain.domain.com" = {
    key_type                  = "RSA"
    key_size                  = 4096
    subject_alternative_names = null
  }
}