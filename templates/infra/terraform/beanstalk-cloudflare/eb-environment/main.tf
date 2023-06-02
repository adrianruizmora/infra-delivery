terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.67.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "3.31.0"
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

module "immutable_elasticbeanstalk" {
  source                = "git::git@github.com:adrianruizmora/infra-delivery.git?ref=immutable-elasticbeanstalk"
  application           = var.application
  environment           = var.environment
  solution_stack        = var.solution_stack
  ssh_access_key        = var.ssh_access_key
  instance_types        = var.instance_types
  healthcheck_endpoint  = var.healthcheck_endpoint
  application_variables = var.application_variables
}

resource "cloudflare_record" "compute" {
  zone_id = var.cloudflare_zone_id
  name    = var.subdomain
  value   = module.immutable_elasticbeanstalk.eb_app_cname
  type    = "CNAME"
  proxied = true
}