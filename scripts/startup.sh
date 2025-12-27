#!/bin/ash
# Byte-H Premium Startup Script

# 1. Branding
echo -e "\n\033[36m██████╗ ██╗   ██╗████████╗███████╗      ██╗  ██╗\n\033[36m██╔══██╗╚██╗ ██╔╝╚══██╔══╝██╔════╝      ██║  ██║\n\033[36m██████╔╝ ╚████╔╝    ██║   █████╗        ███████║\n\033[36m██╔══██╗  ╚██╔╝     ██║   ██╔══╝        ██╔══██║\n\033[36m██████╔╝   ██║      ██║   ███████╗      ██║  ██║\n\033[36m╚═════╝    ╚═╝      ╚═╝   ╚══════╝      ╚═╝  ╚═╝\n\033[32mByte-H Performance Engine\nAuto Optimization: ENABLED\nAI Lag Guard: ACTIVE\033[0m\n"

# 2. Check for Server JAR
if [ ! -f ${SERVER_JARFILE} ]; then
    echo -e "\033[31m[ERROR] Server JAR (${SERVER_JARFILE}) not found!\n\033[31mPlease ensure the server is installed or the jar name is correct.\033[0m"
    exit 1
fi

# 3. Download/Apply Optimized Configs if not present
if [ ! -f server.properties ] && [ "${SERVER_TYPE}" != "velocity" ]; then
    echo -e "\033[33m[Byte-H] Fetching optimized server.properties...\033[0m"
    # We try to download from the repo first, fallback to generating locally if network fails or repo invalid
    if [ ! -z "${GITHUB_USER}" ] && [ ! -z "${GITHUB_REPO}" ] && [ ! -z "${GITHUB_BRANCH}" ]; then
         curl -s -f -o server.properties https://raw.githubusercontent.com/${GITHUB_USER}/${GITHUB_REPO}/${GITHUB_BRANCH}/config/server.properties || echo "Failed to download config, generating locally..."
    fi
    
    if [ ! -f server.properties ]; then
        echo -e "\033[33m[Byte-H] Generating optimized server.properties locally...\033[0m"
        echo -e "view-distance=10\nsimulation-distance=6\nnetwork-compression-threshold=256\nmax-tick-time=60000\nprevent-proxy-connections=false\nuse-native-transport=true\nenable-jmx-monitoring=false\nsync-chunk-writes=true\n" >> server.properties
    fi
fi

# 4. Dynamic RAM Allocation
MEM_HEAP=$((${SERVER_MEMORY} * 95 / 100))
MEM_INIT=$((${SERVER_MEMORY} * 60 / 100))

echo -e "\033[32m[Byte-H] Starting server with ${MEM_HEAP}MB max heap (Xms: ${MEM_INIT}MB)...\033[0m"

# 5. Launch JVM
exec java -Xms${MEM_INIT}M -Xmx${MEM_HEAP}M \
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
    -jar ${SERVER_JARFILE}
