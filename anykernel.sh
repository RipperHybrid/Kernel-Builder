#!/bin/bash

# Get version from GitHub environment variable
version=${VERSION}
workspace=$1  # GitHub workspace directory passed as an argument

# Define the YAML file path based on the provided workspace directory
yaml_file="${workspace}/Sources/KernelSu.yaml"

# Check if version is provided
if [ -z "$version" ]; then
    echo "No version specified. Exiting..."
    exit 1
fi

# Convert the YAML file to JSON
echo -e "Converting YAML to JSON..."
json=$(python -c "import sys, yaml, json; json.dump(yaml.safe_load(open('$yaml_file')), sys.stdout)" )

# Check if json is empty
if [ -z "$json" ]; then
    echo "Failed to convert YAML to JSON. Exiting..."
    exit 1
fi

# Print the converted JSON file
echo -e "\nContents of JSON file:"
echo "$json"

# Parse the JSON file for anykernel
anykernel=$(echo "$json" | jq -r --arg version "$version" '.[$version].anykernel[]')

# Check if anykernel is empty
if [ -z "$anykernel" ]; then
    echo "Failed to parse JSON. Exiting..."
    exit 1
fi

# Parse the JSON file for AnyKernel3 version corresponding to anykernel
anykernel3=$(echo "$json" | jq -r --arg anykernel "$anykernel" '.AnyKernel3.version[$anykernel][]')

# Check if anykernel3 is empty
if [ -z "$anykernel3" ]; then
    echo "Failed to parse JSON. Exiting..."
    exit 1
fi

# Append "AnyKernel3" to the anykernel3 command
anykernel3="${anykernel3} AnyKernel3"

# Print the commands that will be executed
echo -e "\n\033[31mScript will execute following commands corresponding to ${version}:\033[0m"
echo -e "\033[32m$anykernel3\033[0m"

# Execute the command
eval "$anykernel3"
