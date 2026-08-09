#!/bin/bash
set -e

# Pindah ke direktori utama proyek
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_DIR"

# Tulis file .env dari environment variable ENV_CONTENT jika ada
if [ -n "$ENV_CONTENT" ]; then
    printf '%s\n' "$ENV_CONTENT" > .env
fi

export PORT=10040
export NODE_ENV=production
APP_NAME="go-backend"
BINARY_PATH="./main"

# Beri izin eksekusi pada binary Go
if [ -f "$BINARY_PATH" ]; then
    chmod +x "$BINARY_PATH"
fi

# Load NVM & Node/PM2 PATH jika ada (silent)
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    source "$NVM_DIR/nvm.sh" > /dev/null 2>&1
fi

if [ -d "$NVM_DIR/versions/node" ]; then
    LATEST_NODE=$(ls "$NVM_DIR/versions/node" 2>/dev/null | tail -n 1)
    if [ -n "$LATEST_NODE" ]; then
        export PATH="$NVM_DIR/versions/node/$LATEST_NODE/bin:$PATH"
    fi
fi

# Restart jika sudah berjalan di PM2, atau start baru binary Go secara SILENT
pm2 restart "$APP_NAME" --update-env > /dev/null 2>&1 || pm2 start "$BINARY_PATH" --name "$APP_NAME" > /dev/null 2>&1

# Simpan konfigurasi PM2 secara SILENT
pm2 save > /dev/null 2>&1
