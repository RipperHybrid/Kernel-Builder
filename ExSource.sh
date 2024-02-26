#!/bin/bash

# Extract sources script

version="${VERSION}"
workspace="$1"

YAML_PATH="${workspace}/Sources/${version}.yaml"

# Check if the YAML file exists
if [ -f "$YAML_PATH" ]; then
    # Print the content of the YAML file
    echo "Contents of $VERSION.yaml:"
    cat "$YAML_PATH"

    # Convert the YAML file to JSON
    json=$(python -c "import sys, yaml, json; print(json.dumps(yaml.safe_load(open('$YAML_PATH'))))" 2>/dev/null)

    # Print the converted JSON content
    echo "Converted JSON content:"
    echo "$json"

    # Extract URLs from the JSON content dynamically
    for VERSION_NAME in $(echo "$json" | jq -r 'keys[]'); do
        KERNEL_URL=$(echo "$json" | jq -r ".[\"$VERSION_NAME\"].kernel[0]" | cut -d ' ' -f 3)
        echo "$VERSION_NAME URL: $KERNEL_URL"
        # Set the extracted URL as the KERNEL_URL environment variable in the GitHub environment
        echo "KERNEL_URL=$KERNEL_URL" >> $GITHUB_ENV
    done
else
    echo "Error: $YAML_PATH not found."
    exit 1
fi
