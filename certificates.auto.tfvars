certificates = {
  "*.yourdomain.com" = {
    key_type                  = "RSA"
    key_size                  = 4096
    subject_alternative_names = ["yourdomain.nl"]
  },
  "subdomain.yourdomain.com" = {
    key_type                  = "RSA"
    key_size                  = 4096
    subject_alternative_names = null
  }
}