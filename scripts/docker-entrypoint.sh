#!/bin/sh
set -e

# Ensure /paperclip is owned by the node user
chown -R node:node /paperclip

# Switch to the node user and /app directory
export HOME=/paperclip
cd /app

# Run onboard if the instance config doesn't exist
if [ ! -f "/paperclip/instances/default/config.json" ]; then
  echo "Initializing Paperclip instance..."
  gosu node pnpm paperclipai onboard --non-interactive
fi

# Start the server
echo "Starting Paperclip server..."
exec gosu node node --import ./server/node_modules/tsx/dist/loader.mjs server/dist/index.js
