#!/bin/ash
# Byte-H Premium Installation Script
# This script is designed to be pulled from GitHub by the Pterodactyl Egg

apk add --no-cache curl jq

PROJECT="${SERVER_TYPE}"
VERSION="${MINECRAFT_VERSION}"
JAR_NAME="${SERVER_JARFILE}"

mkdir -p /mnt/server
cd /mnt/server

echo -e "\033[36m[Byte-H] Installing ${PROJECT} (${VERSION})...\033[0m"

if [ "${PROJECT}" == "paper" ]; then
    if [ "${VERSION}" == "latest" ]; then
        MC_VER=$(curl -s https://api.papermc.io/v2/projects/paper | jq -r '.versions[-1]')
    else
        MC_VER=${VERSION}
    fi
    BUILD=$(curl -s https://api.papermc.io/v2/projects/paper/versions/${MC_VER} | jq -r '.builds[-1]')
    echo "Downloading Paper version ${MC_VER} build ${BUILD}..."
    curl -o ${JAR_NAME} https://api.papermc.io/v2/projects/paper/versions/${MC_VER}/builds/${BUILD}/downloads/paper-${MC_VER}-${BUILD}.jar

elif [ "${PROJECT}" == "purpur" ]; then
    if [ "${VERSION}" == "latest" ]; then
        echo "Resolving latest Purpur version..."
        curl -o ${JAR_NAME} https://api.purpurmc.org/v2/purpur/joy/latest/download
    else
        echo "Downloading Purpur version ${VERSION}..."
        curl -o ${JAR_NAME} https://api.purpurmc.org/v2/purpur/${VERSION}/latest/download
    fi

elif [ "${PROJECT}" == "velocity" ]; then
    if [ "${VERSION}" == "latest" ]; then
        MC_VER=$(curl -s https://api.papermc.io/v2/projects/velocity | jq -r '.versions[-1]')
    else
        MC_VER=${VERSION}
    fi
    BUILD=$(curl -s https://api.papermc.io/v2/projects/velocity/versions/${MC_VER} | jq -r '.builds[-1]')
    echo "Downloading Velocity version ${MC_VER} build ${BUILD}..."
    curl -o ${JAR_NAME} https://api.papermc.io/v2/projects/velocity/versions/${MC_VER}/builds/${BUILD}/downloads/velocity-${MC_VER}-${BUILD}.jar
else
    echo "Unknown server type: ${PROJECT}"
    exit 1
fi


# ------------------------------------------------------------------------------------------------
# PREMIUM FEATURE: Geyser & Floodgate Auto-Installer
# ------------------------------------------------------------------------------------------------
if [ "${INSTALL_GEYSER}" == "1" ] || [ "${INSTALL_GEYSER}" == "true" ]; then
    echo -e "\033[36m[Byte-H] Bedrock Support Enabled! Installing Geyser & Floodgate...\033[0m"
    mkdir -p /mnt/server/plugins
    
    # Geyser
    echo "Downloading Geyser-Spigot..."
    curl -o /mnt/server/plugins/Geyser-Spigot.jar "https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/spigot"
    
    # Floodgate
    echo "Downloading Floodgate-Spigot..."
    curl -o /mnt/server/plugins/Floodgate-Spigot.jar "https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/spigot"
    
    echo -e "\033[32m[Byte-H] Geyser & Floodgate installed successfully!\033[0m"
fi

echo -e "\033[32m[Byte-H] Installation Complete!\033[0m"
