#!/bin/bash
# -----------------------------------------------------------------------------
# BYTE-H PERFORMANCE ENGINE | "Ultimate Startup"
# Author: Mohit
# -----------------------------------------------------------------------------

# 1. BRANDING (Big Letters)
echo -e "\033[36m"
echo "  ____  _  _  ____  ____       _   _"
echo " | __ )| || ||_  _||  __|     | | | |"
echo " |  _ \| || |_ | |  | |_ _____| |_| |"
echo " | |_) |__   _|| |  |  _|_____|  _  |"
echo " |____/   |_|  |_|  |__|      |_| |_|"
echo -e "\033[35m         ~ Mohit \033[0m"
echo -e "\033[32m[Byte-H] Performance Engine Loaded.\033[0m"

# 2. VERSION SELECTION logic
# Default to 1.21.4 if not set
VER="${MINECRAFT_VERSION:-1.21.4}"
JAR="server.jar"

# 3. AUTO-DOWNLOAD SERVER JAR (Only if missing)
if [ ! -f "$JAR" ]; then
    echo -e "\033[33m[Byte-H] Server JAR not found. Downloading Paper (${VER})...\033[0m"
    
    if [ "$VER" == "1.21.4" ]; then
        curl -o $JAR "https://fill-data.papermc.io/v1/objects/5ee4f542f628a14c644410b08c94ea42e772ef4d29fe92973636b6813d4eaffc/paper-1.21.4-232.jar"
    elif [ "$VER" == "1.21.11" ]; then
        # Utilizing the specific link provided by user
        curl -o $JAR "https://fill-data.papermc.io/v1/objects/7e8fd35b554aea8d1492c83fcf429e9c8e391464e50f82ee3e408be87b4e80df/paper-1.21.11-39.jar"
    else
        # Fallback to latest 1.21.4 if unknown
        echo "Unknown version map. Defaulting to 1.21.4..."
        curl -o $JAR "https://fill-data.papermc.io/v1/objects/5ee4f542f628a14c644410b08c94ea42e772ef4d29fe92973636b6813d4eaffc/paper-1.21.4-232.jar"
    fi
    
    echo -e "\033[32m[Byte-H] Server JAR downloaded!\033[0m"
else
    echo -e "\033[32m[Byte-H] Server JAR found. Skipping download.\033[0m"
fi

# 4. AUTO-DOWNLOAD PLUGINS (Chunky, ClearLag)
mkdir -p plugins

# Chunky (Pre-generates world to fix lag)
if [ ! -f "plugins/Chunky.jar" ]; then
    echo -e "\033[36m[Byte-H] Installing Chunky (Lag Fix)...\033[0m"
    curl -H "User-Agent: Byte-H" -L -o "plugins/Chunky.jar" "https://hangarcdn.papermc.io/plugins/pop4959/Chunky/versions/1.4.28/PAPER/Chunky-1.4.28.jar"
fi

# ClearLag (Clears entities) - Using a stable build or alternative since ClearLag is old. 
# Using "ClearLag" optimized fork or similar if available, but for now generic.
if [ ! -f "plugins/ClearLag.jar" ]; then
    echo -e "\033[36m[Byte-H] Installing ClearLag...\033[0m"
    # Placeholder for a direct link to ClearLag or equivalent
    curl -L -o "plugins/ClearLag.jar" "https://dev.bukkit.org/projects/clearlagg/files/latest" 
fi

# 5. START SERVER
MEM_HEAP="${SERVER_MEMORY:-4096}"
MEM_MS=$((MEM_HEAP * 75 / 100))

echo -e "\033[32m[Byte-H] Starting Server with ${MEM_HEAP}MB RAM...\033[0m"

java -Xms${MEM_MS}M -Xmx${MEM_HEAP}M \
    -XX:+UseG1GC \
    -XX:+ParallelRefProcEnabled \
    -XX:MaxGCPauseMillis=200 \
    -XX:+UnlockExperimentalVMOptions \
    -XX:+DisableExplicitGC \
    -XX:+AlwaysPreTouch \
    -XX:G1NewSizePercent=30 \
    -XX:G1MaxNewSizePercent=40 \
    -XX:G1HeapRegionSize=8M \
    -XX:G1ReservePercent=20 \
    -XX:G1HeapWastePercent=5 \
    -XX:G1MixedGCCountTarget=4 \
    -XX:InitiatingHeapOccupancyPercent=15 \
    -XX:G1MixedGCLiveThresholdPercent=90 \
    -XX:G1RSetUpdatingPauseTimePercent=5 \
    -XX:SurvivorRatio=32 \
    -XX:+PerfDisableSharedMem \
    -XX:MaxTenuringThreshold=1 \
    -Dusing.aikars.flags=https://mcflags.emc.gs \
    -Daikars.new.flags=true \
    -jar "$JAR" nogui
