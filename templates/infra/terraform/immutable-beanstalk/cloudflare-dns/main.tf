terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "4.7.1"
    }
  }
}


// Uncomment to Run locally
// provider "aws" {
//   shared_config_files      = [""]
//   shared_credentials_files = [""]
//   profile                  = "default"
// }

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

resource "cloudflare_record" "compute" {
  zone_id = var.cloudflare_zone_id
  name = var.subdomain
  value = var.eb_app_cname
  type = "CNAME"
  proxied = true
}

