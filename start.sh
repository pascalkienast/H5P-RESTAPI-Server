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

# Change to app directory before running npm commands
cd /app

# Check if we need to build the application (assuming build output goes somewhere in /app, not /app/data)
if [ ! -d "packages/h5p-server/build" ]; then
  echo "==> Building application..."
  # Run build processes individually to avoid errors stopping the startup
  npm run build || echo "Warning: build failed"
  #npm run build:h5p-server || echo "Warning: Server build failed"
 # npm run build:h5p-express || echo "Warning: Express build failed"
  #npm run build:h5p-html-exporter || echo "Warning: HTML exporter build failed"
  #npm run build:h5p-react || echo "Warning: React build failed"
 # npm run build:h5p-webcomponents || echo "Warning: Web components build failed"
fi

# Start the application as the cloudron user for security
echo "==> Starting the application..."
exec /usr/local/bin/gosu cloudron:cloudron npm start 