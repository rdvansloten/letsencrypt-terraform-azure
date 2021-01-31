terraform {
  required_version = ">= 0.13"

  required_providers {
    acme = {
      source  = "vancluever/acme"
      version = "~>1.6.3"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.41.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.0.0"
    }
  }

  /* 
  # Optional remote backend
  backend "azurerm" {
    resource_group_name = "RESOURCE_GROUP_NAME_HERE"
    container_name      = "CONTAINER_NAME_HERE"
    key                 = "FILE_NAME_HERE.tfstate"
  }
  */
}

provider "azurerm" {

  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

provider "tls" {

}