#!/bin/bash

# Extract version and workspace from the arguments
version="${VERSION}"
workspace="$1"

# Define the path to the Makefile
MAKEFILE_PATH="${workspace}/kernel/Makefile"

# Extract the kernel version from the Makefile
if [ -f "$MAKEFILE_PATH" ]; then
    KERNEL_VERSION=$(grep "^VERSION" "$MAKEFILE_PATH" | awk '{print $3}')
    KERNEL_PATCHLEVEL=$(grep "^PATCHLEVEL" "$MAKEFILE_PATH" | awk '{print $3}')
    KERNEL_SUBLEVEL=$(grep "^SUBLEVEL" "$MAKEFILE_PATH" | awk '{print $3}')
    FULL_KERNEL_VERSION="${KERNEL_VERSION}.${KERNEL_PATCHLEVEL}.${KERNEL_SUBLEVEL}"

    # Set environment variable with the kernel version for the specific version
    echo "KERNEL_VERSION=${FULL_KERNEL_VERSION}" >> $GITHUB_ENV
    echo "Extracted ${version} kernel version: ${FULL_KERNEL_VERSION} from ${MAKEFILE_PATH}"
else
    echo "Makefile not found in the kernel directory." >&2
    ls -R "${workspace}/kernel"
fi
