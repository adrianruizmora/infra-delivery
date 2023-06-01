remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = get_env("TF_VAR_backend_bucket_name")

    key = "${get_env("TF_VAR_application")}/${get_env("TF_VAR_environment")}/terraform.tfstate"
    region         = "${get_env("TF_VAR_aws_region")}"
    encrypt        = true
    dynamodb_table = "${get_env("TF_VAR_application")}-lock"
  }
}

dependency "elasticbeanstalk_application" {
  config_path = "../eb-app"
  mock_outputs = {
  eb_app_name = "demo-infra-app"
  }
}

inputs = {
  application = dependency.elasticbeanstalk_application.outputs.eb_app_name
}