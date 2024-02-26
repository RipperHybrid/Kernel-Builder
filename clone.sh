#!/bin/bash

# Get version from GitHub environment variable
version=${VERSION}
workspace=$1  # GitHub workspace directory passed as argument

# Check if version is provided
if [ -z "$version" ]; then
    echo "No version specified. No kernel or clang will be cloned. Exiting..."
    exit 1
fi

# Define the YAML file path based on the provided version and workspace directory
yaml_file="${workspace}/Sources/${version}.yaml"

# List the contents of the workspace directory and its subdirectories for debugging purposes
echo "Contents of workspace directory:"
ls -R "${workspace}"

# Print out the contents of the YAML file
echo "Contents of YAML file (${yaml_file}):"
cat "${yaml_file}"

# Check if the YAML file exists
if [ ! -f "$yaml_file" ]; then
    echo "YAML file $yaml_file not found for version $version. Exiting..."
    exit 1
fi

# Convert the YAML file to JSON and print the JSON content
echo "Converting YAML to JSON:"
json=$(python -c "import sys, yaml, json; print(json.dumps(yaml.safe_load(open('$yaml_file')), indent=2))")
echo "$json"

# Parse the JSON file and extract commands
kernel_commands=$(echo "$json" | jq -r '.["'${version}'"].kernel[]')
clang_commands=$(echo "$json" | jq -r '.["'${version}'"].clang[]')

# Print the commands that will be executed
echo -e "\033[31mClone.sh will execute the following commands corresponding to ${version}:\033[0m"
echo "$kernel_commands" | while read -r command; do
    echo -e "\033[32m$command\033[0m"
done
echo "$clang_commands" | while read -r command; do
    echo -e "\033[32m$command\033[0m"
done

# Clone the kernel and append clone path to the command
echo "$kernel_commands" | while read -r command; do
    eval "$command ${workspace}/kernel"
done

# Clone the clang and append clone path to the command
echo "$clang_commands" | while read -r command; do
    eval "$command ${workspace}/kernel/clang"
done
