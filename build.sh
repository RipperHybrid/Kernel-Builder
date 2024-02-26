#!/bin/bash

# Get version from GitHub environment variable
version=${VERSION}
workspace=$1

# Debugging: Print the values of workspace and version
echo "Workspace: ${workspace}"
echo "Version: ${version}"

# Define the YAML file path based on the provided version and workspace directory
yaml_file="${workspace}/Sources/${version}.yaml"

# Debugging: Print the constructed YAML file path
echo "YAML File Path: ${yaml_file}"

# Convert the YAML file to JSON
echo "Converting YAML to JSON:"
json=$(python -c "import sys, yaml, json; print(json.dumps(yaml.safe_load(open('$yaml_file')), indent=2))")

# Check if json is empty
if [ -z "$json" ]; then
    echo "Failed to convert YAML to JSON. Exiting..."
    exit 1
fi

# Parse the JSON file
config_commands=$(echo $json | jq -r --arg version "$version" '.[$version].config[]')
build_commands=$(echo $json | jq -r --arg version "$version" '.[$version].build[]')

# Check if config_commands and build_commands are empty
if [ -z "$config_commands" ] || [ -z "$build_commands" ]; then
    echo "Failed to parse JSON. Exiting..."
    exit 1
fi

# Print the commands that will be executed
echo -e "\033[31mBuild.sh will execute following commands corresponding to ${version}:\033[0m"
echo "$config_commands" | while read -r command; do
    echo -e "\033[32m$command\033[0m"
done
echo "$build_commands" | while read -r command; do
    echo -e "\033[32m$command\033[0m"
done

# Enter the kernel directory
cd kernel || exit 1

# Execute the config commands
echo "$config_commands" | while read -r command; do
    eval "$command"
done

# Execute the build commands
echo "$build_commands" | while read -r command; do
    eval "$command"
done
