#!/bin/bash

set -e

source ./set_tf_vars.sh
./set_tf_vars.sh

# Create elasticbeanstalk application independently from environments
modules=("eb-app" "$TF_VAR_environment")

for module in "${modules[@]}"; do
    cd "$module"
    echo yes | terragrunt init --terragrunt-non-interactive
    echo yes | terragrunt apply --terragrunt-non-interactive
    cd ..
done