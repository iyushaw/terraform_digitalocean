terraform {
  required_version = ">= 0.12"
  required_providers {
    digitalocean = {
        source = "digitalocean/digitalocean"
    }
    local = ">= 1.2"
  }
}

provider "digitalocean" {
  token = var.do_action
}
