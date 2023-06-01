#!/bin/bash

# Function to update CLI
update_cli() {
    echo "Updating CLI with latest changes..."
    # Add your update command here
    # For example: "git pull" or any other command to update the CLI
}

# Function to create directory structure and copy files
copy_files() {
    local path="$1"

    if [[ ! -d "$path" ]]; then
        echo "Path does not exist: $path"
        return
    fi

    local infra_dir="$path/infra/terraform"

    if [[ -d "$infra_dir" ]]; then
        read -p "The $infra_dir directory already exists. Do you want to overwrite it? (y/n): " choice
        if [[ "$choice" != "y" ]]; then
            echo "Aborted."
            return
        else
            rm -rf "$infra_dir"
            mkdir -p "$infra_dir/eb-app"
            mkdir -p "$infra_dir/dev"
            mkdir -p "$infra_dir/prod"
            echo "Overwritten existing directory structure in $path"
        fi
    else
        mkdir -p "$infra_dir/eb-app"
        mkdir -p "$infra_dir/dev"
        mkdir -p "$infra_dir/prod"
        echo "Created directory structure in $path"
    fi

    local template_immutable_beanstalk="./templates/infra/terraform/beanstalk-cloudflare" # add be able to choose template
    local eb_app_source_dir="$template_immutable_beanstalk/eb-app"
    local eb_environment_source_dir="$template_immutable_beanstalk/eb-environment"

    cp -r "$eb_app_source_dir/." "$infra_dir/eb-app" 
    cp -r "$eb_environment_source_dir/." "$infra_dir/dev"
    cp -r "$eb_environment_source_dir/." "$infra_dir/prod"
    cp "$template_immutable_beanstalk/"*.sh "$infra_dir"

    echo "Files copied successfully."
}

# Main script
if [[ "$1" == "update" ]]; then
    update_cli
elif [[ "$1" == "copy" ]]; then
    copy_files "$2"
else
    echo "Invalid option. Usage: ./script.sh [update|copy <path>]"
fi
