remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = get_env("TF_VAR_backend_bucket_name")

    key = "${get_env("TF_VAR_application")}/${basename(get_env("PWD"))}/terraform.tfstate"
    region         = "${get_env("TF_VAR_aws_region")}"
    encrypt        = true
    dynamodb_table = "${get_env("TF_VAR_application")}-lock"
  }
}

dependency "elasticbeanstalk_environment" {
  config_path = "../eb-environment"
  mock_outputs = {
  #eb_app_cname = "demo-infra-app"
  }
}

inputs = {
  eb_app_cname = dependency.elasticbeanstalk_environment.outputs.eb_app_cname
}