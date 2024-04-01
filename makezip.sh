#!/bin/bash

# Get the build date from environment variables
BUILD_DATE=${BUILD_DATE:-$(TZ=Asia/Manila date +'%d-%m-%Y')}

# Get the version from the GitHub environment variable
version="${VERSION}"

# Get ZIP names for kernels from GitHub environment variables
zip_no_ksu="${ZIP_NO_KSU}"
zip_ksu="${ZIP_KSU}"

# Function to modify anykernel.sh with the version
modify_anykernel_with_version() {
    sed -i "s/kernel.string=.*/kernel.string=Auto-Built Kernel for Realme 8 (Nashc) - Version: ${version}/" AnyKernel3/anykernel.sh
}

# Function to copy kernel images and zip them
copy_and_zip_kernels() {
    local output_dir=$1
    local outw_dir=$2
    local zip_name=$3

    COPIED_FILES=""
    for file in "$outw_dir"/*; do
        # Add the build date to the file name
        new_name="$(basename "${file%.*}")-${BUILD_DATE}.${file##*.}"
        cp "$file" "AnyKernel3/$new_name"
        COPIED_FILES="${COPIED_FILES} $(basename "$new_name")"
    done

    # Enter AnyKernel3 directory
    cd AnyKernel3 || exit

    # Modify anykernel.sh with the version
    modify_anykernel_with_version

    # Zip the kernel
    zip -r9 "${output_dir}/${zip_name}" *

    # Move the ZIP to the output directory
    mv "${zip_name}" "${output_dir}/${zip_name}"

    # Remove the copied files from the AnyKernel3 directory
    for file in $COPIED_FILES; do
        rm -f "$file"
    done

    # Return to the previous directory
    cd - || exit
}

# Copy and zip kernel images without KernelSU support
copy_and_zip_kernels "$GITHUB_WORKSPACE" "outw/false" "$zip_no_ksu"

# Copy and zip kernel images with KernelSU support
copy_and_zip_kernels "$GITHUB_WORKSPACE" "outw/true" "$zip_ksu"
