#!/bin/bash

# Define some colors
GREEN='\033[32m'
RED='\033[31m'
NC='\033[0m' # No Color

# Define cleaning commands directly in the script
out_commands=(
    "rm -rf out"
)
kernel_commands=(
    "make mrproper"
)
custom_commands=(
    "git status"
)

# Print the commands that will be executed
echo -e "${GREEN}Clean.sh will execute following commands:${NC}"
echo "${out_commands[@]}" | while read -r command; do
    echo -e "${RED}$command${NC}"
done
echo "${kernel_commands[@]}" | while read -r command; do
    echo -e "${RED}$command${NC}"
done
echo "${custom_commands[@]}" | while read -r command; do
    echo -e "${RED}$command${NC}"
done

# Enter kernel directory
cd kernel

# Execute the out commands
echo "${out_commands[@]}" | while read -r command; do
    eval "$command"
done

# Execute the kernel commands
echo "${kernel_commands[@]}" | while read -r command; do
    eval "$command"
done

# Execute the custom commands
echo "${custom_commands[@]}" | while read -r command; do
    eval "$command"
done
