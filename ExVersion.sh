#!/bin/bash

# Extract version and workspace from the arguments
version="${VERSION}"
workspace="$1"

# Define your Telegram chat ID and bot token from secrets
TELEGRAM_CHAT_ID="${TELEGRAM_CHAT_ID}"
TELEGRAM_BOT_TOKEN="${TELEGRAM_BOT_TOKEN}"

# Function to send Telegram message
send_telegram_message() {
    message="$1"
    version_info="$2"
    curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
        -d "chat_id=${TELEGRAM_CHAT_ID}" \
        -d "text=${message} Version: ${version_info}"
}

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

    # Send Telegram message for successful extraction
    send_telegram_message "Kernel version extraction successful for ${version}." "${FULL_KERNEL_VERSION}"
else
    echo "Makefile not found in the kernel directory." >&2
    ls -R "${workspace}/kernel"

    # Send Telegram message for failure
    send_telegram_message "Kernel version extraction failed for ${version}. Makefile not found." ""
fi
