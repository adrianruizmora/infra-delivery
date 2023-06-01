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


resource "aws_elastic_beanstalk_application" "compute" {
  name = var.application
}

