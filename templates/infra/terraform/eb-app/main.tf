terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.67.0"
    }
  }
}


// Uncomment to Run locally
// provider "aws" {
//   shared_config_files      = [""]
//   shared_credentials_files = [""]
//   profile                  = "default"
// }

module "tf-backend" {
  source              = "git::git@github.com:adrianruizmora/infra-delivery.git?ref=tf-backend"
  backend_bucket_name = var.backend_bucket_name
}

resource "aws_elastic_beanstalk_application" "compute" {
  name = var.application
}

