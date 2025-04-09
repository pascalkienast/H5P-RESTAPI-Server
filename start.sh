#!/bin/bash
set -e

# Print environment information for debugging
echo "==> Starting H5P REST API Server"
echo "==> Node version: $(node -v)"
echo "==> NPM version: $(npm -v)"

# Directory setup - Cloudron uses /app/data for persistent storage
mkdir -p /app/data/storage
mkdir -p /app/data/logs

# Set proper permissions for data directories as recommended by Cloudron
# These directories ARE writable at runtime
chown -R cloudron:cloudron /app/data/storage /app/data/logs
chmod -R 755 /app/data/storage /app/data/logs

# Set environment variables
export DATA_DIR="/app/data/storage"
export LOG_DIR="/app/data/logs"

# Change to app directory (optional, as exec command is absolute)
cd /app

# === Removed Build Step ===
# The application build should happen in the Dockerfile, not at runtime.
# if [ ! -d "packages/h5p-server/build" ]; then
#   echo "==> Building application..."
#   npm run build || echo "Warning: build failed"
# fi

# Start the application as the cloudron user for security
echo "==> Starting the application..."
# Ensure the build output path is correct based on your build process
exec /usr/local/bin/gosu cloudron:cloudron node packages/h5p-main/build/express.js 