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

dependency "elasticbeanstalk-application" {
  config_path = "../eb-app"
  mock_outputs = {
  eb-app-name = "demo-infra-app"
  }
}

inputs = {
  application = dependency.elasticbeanstalk-application.outputs.eb-app-name
}