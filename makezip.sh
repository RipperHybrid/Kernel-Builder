#!/bin/bash

# Get ZIP name for kernel without KernelSU from GitHub environment variable
zip_no_ksu="${ZIP_NO_KSU}"

# Get ZIP name for kernel with KernelSU from GitHub environment variable
zip_ksu="${ZIP_KSU}"

# Copy the kernel image to the AnyKernel3 directory and store the names of the copied files in an environment variable
COPIED_FILES=""
for file in outw/false/*; do
    # Add the build date to the file name
    new_name="$(basename "${file%.*}")-${BUILD_DATE}.${file##*.}"
    cp "$file" "AnyKernel3/$new_name"
    COPIED_FILES="${COPIED_FILES} $(basename "$new_name")"
done

# Enter AnyKernel3 directory
cd AnyKernel3 || exit

# Zip the kernel
zip -r9 "${zip_no_ksu}" *

# Move the ZIP to Github workspace
mv "${zip_no_ksu}" "${GITHUB_WORKSPACE}/"

# Remove the copied files from the AnyKernel3 directory
for file in $COPIED_FILES; do
    rm -f "$file"
done

# Enter GitHub workspace
cd "${GITHUB_WORKSPACE}" || exit

# Copy the kernel image with KernelSU support to the AnyKernel3 directory and store the names of the copied files in an environment variable
COPIED_FILES=""
for file in outw/true/*; do
    # Add the build date to the file name
    new_name="$(basename "${file%.*}")-${BUILD_DATE}.${file##*.}"
    cp "$file" "AnyKernel3/$new_name"
    COPIED_FILES="${COPIED_FILES} $(basename "$new_name")"
done

# Enter AnyKernel3 directory
cd AnyKernel3 || exit

# Zip the kernel
zip -r9 "${zip_ksu}" *

# Move the ZIP to Github workspace
mv "${zip_ksu}" "${GITHUB_WORKSPACE}/"
