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


module "immutable-elasticbeanstalk" {
  depends_on = [ aws_elastic_beanstalk_application.compute ]
  source         = "git::git@github.com:adrianruizmora/infra-delivery.git?ref=immutable-elasticbeanstalk"
  application    = var.application
  environment    = var.environment
  solution_stack = var.solution_stack
  ssh_access_key = var.ssh_access_key
  instance_types = var.instance_types
  healthcheck_endpoint = var.healthcheck_endpoint
  application_variables = var.application_variables
}