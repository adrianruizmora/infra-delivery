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