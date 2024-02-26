#!/bin/bash

# Define some colors
RED='\033[31m'
GREEN='\033[32m'
NC='\033[0m' # No Color

# Get version from GitHub environment variable
version=${VERSION}
workspace=$1  # GitHub workspace directory passed as argument

# Check if version is provided
if [ -z "$version" ]
then
    echo -e "${RED}No version specified. No targets will be moved. Exiting...${NC}"
    exit 1
fi

# Define the YAML file path based on the provided version and workspace directory
yaml_file="${workspace}/Sources/${version}.yaml"

# Convert the YAML file to JSON and print the JSON content
echo "Converting YAML to JSON:"
json=$(python -c "import sys, yaml, json; print(json.dumps(yaml.safe_load(open('$yaml_file')), indent=2))")
echo "$json"

# Check if json is empty
if [ -z "$json" ]
then
    echo -e "${RED}Failed to convert YAML to JSON. Exiting...${NC}"
    exit 1
fi

# Parse the JSON file to get the target
target=$(echo $json | jq -r --arg version "$version" '.[$version].target[]')

# Check if target is empty
if [ -z "$target" ]
then
    echo -e "${RED}Failed to parse JSON. Exiting...${NC}"
    exit 1
fi

# Add 'kernel' to the target path
target="${GITHUB_WORKSPACE}/kernel/$target"

# Check the KERNELSU environment variable and move the target to the appropriate directory
if [ "${KERNELSU}" == "true" ]
then
    mv $target "${GITHUB_WORKSPACE}/outw/true"
else
    mv $target "${GITHUB_WORKSPACE}/outw/false"
fi
