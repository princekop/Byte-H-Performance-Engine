#!/bin/bash
# Byte-H Install Helper
# We don't really need this if startup.sh does everything,
# but Pterodactyl expects an install script.

# Detect OS
if command -v apk >/dev/null 2>&1; then
    apk add --no-cache curl
elif command -v apt-get >/dev/null 2>&1; then
    apt-get update && apt-get install -y curl
fi

echo "Detailed installation happens on first startup!"
touch installed
