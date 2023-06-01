#!/bin/bash

export TF_VAR_backend_bucket_name=""
export TF_VAR_aws_region=""
export TF_VAR_application="$EB_APP_NAME" # Set by pipeline
export TF_VAR_environment="$ENVIRONMENT" # Set by pipeline
export TF_VAR_solution_stack=""
export TF_VAR_ssh_access_key=""
export TF_VAR_healthcheck_endpoint=""
#export TF_VAR_application_variables='{"key1": "value1", "key2": "value2"}'