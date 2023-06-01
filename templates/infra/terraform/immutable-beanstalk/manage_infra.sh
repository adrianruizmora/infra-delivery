#!/bin/bash

set -e

source ./set_tf_vars.sh

# Create elasticbeanstalk application independently from environments
modules=("eb-app" "$TF_VAR_environment" "cloudflare-dns")

valid_command=false

while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        --deploy)
            valid_command=true
            command="apply"
            shift
            ;;
        --destroy)
            valid_command=true
            command="destroy"
            shift
            ;;
        *)
            echo "Invalid option: $key"
            echo "Available options: --deploy, --destroy"
            exit 1
            ;;
    esac
done

if [ "$valid_command" = false ]; then
    echo "Please specify a command: --deploy, --destroy"
    exit 1
fi

if [ "$command" = "destroy" ]; then
    modules=("${modules[@]:(-1)}" "${modules[@]::${#modules[@]}-1}") # Reverse the order of modules for destroy command
fi

for module in "${modules[@]}"; do
    cd "$module"
    echo yes | terragrunt init --terragrunt-non-interactive
    echo yes | terragrunt "$command" --terragrunt-non-interactive
    cd ..
done
