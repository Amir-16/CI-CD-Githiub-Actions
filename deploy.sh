#!/bin/bash
set -e

echo "========================================="
echo " Deploying Node Express App"
echo "========================================="

echo "[1/3] Installing production dependencies..."
npm ci --omit=dev

echo "[2/3] Starting / restarting application with PM2..."
pm2 restart node-express-app 2>/dev/null \
  || pm2 start src/server.js --name node-express-app

echo "[3/3] Saving PM2 process list..."
pm2 save

echo "========================================="
echo " Deployment complete!"
echo " App running at http://localhost:${PORT:-3000}"
echo "========================================="
