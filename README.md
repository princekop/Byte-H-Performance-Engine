# Byte-H Performance Engine

Premium High-Performance Minecraft Egg for Pterodactyl, optimized for Paper, Purpur, and Velocity.

## Features
- **Auto-Optimization**: Automatically applies G1GC flags and tunes `server.properties`.
- **Dynamic RAM**: intelligent Xms/Xmx allocation.
- **Modular Design**: Scripts are fetched from GitHub, allowing for instant updates across all servers without modifying the egg.
- **Premium Branding**: ASCII art startup and "AI Lag Guard" status.

## Installation

### 1. GitHub Setup
These files are synchronized with the repository: `https://github.com/princekop/Byte-H-Performance-Engine`

### 2. Panel Import
1.  Go to your Pterodactyl Admin Panel > **Nests** > **Import Egg**.
2.  Select `egg/byte-h-performance.json` from this folder.
3.  Select the **Minecraft** nest.

### 3. Usage
When creating a server using this egg, you will see three new variables which default to:
- **GitHub Username**: `princekop`
- **GitHub Repo**: `Byte-H-Performance-Engine`
- **GitHub Branch**: `main`

The server will automatically pull the latest `install.sh` and `startup.sh` from your repo every time it starts or installs.

## Directory Structure
- `egg/`: Contains the JSON egg file to import into Pterodactyl.
- `scripts/`: Contains `install.sh` and `startup.sh` (logic lies here).
- `config/`: Contains the optimized `server.properties`.

## Customization
To update the logic for all your clients, simply edit `scripts/startup.sh` locally and push to GitHub. All servers will use the new logic on their next restart!
