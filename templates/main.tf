module "tf-backend" {
  source              = "git::git@github.com:adrianruizmora/infra-delivery.git?ref=tf-backend"
  backend_bucket_name = var.backend_bucket_name
}

module "immutable-elasticbeanstalk" {
  source         = "git::git@github.com:adrianruizmora/infra-delivery.git?ref=immutable-elasticbeanstalk"
  application    = var.application
  environment    = var.environment
  solution_stack = var.solution_stack
  ssh_access_key = var.ssh_access_key
  instance_types = var.instance_types
  healthcheck_endpoint = var.healthcheck_endpoint
  application_variables = var.application_variables
}