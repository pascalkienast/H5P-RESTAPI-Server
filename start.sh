#!/bin/bash
set -e

# Make script executable on container startup
chmod +x /app/start.sh

# Print environment information for debugging
echo "==> Starting H5P REST API Server"
echo "==> Node version: $(node -v)"
echo "==> NPM version: $(npm -v)"

# Directory setup - Cloudron uses /app/data for persistent storage
mkdir -p /app/data/storage
mkdir -p /app/data/logs

# Set environment variables
export DATA_DIR="/app/data/storage"
export LOG_DIR="/app/data/logs"

# Create symlinks if necessary
cd /app

# Install dependencies if they're not already installed
if [ ! -d "node_modules" ]; then
  echo "==> Installing dependencies..."
  npm install
fi

# Start the application
echo "==> Starting the application..."
exec npm start 