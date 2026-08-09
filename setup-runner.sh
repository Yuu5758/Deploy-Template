#!/bin/bash
set -e

# ==============================================================================
# Script Instalasi & Setup GitHub Self-Hosted Runner sebagai Systemd Service
# ==============================================================================

# Pastikan parameter URL dan TOKEN diberikan
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Error: Argumen tidak lengkap."
    echo "Usage: bash setup-runner.sh <REPO_URL_ATAU_ORG_URL> <RUNNER_TOKEN> [RUNNER_DIR]"
    echo "Contoh: bash setup-runner.sh https://github.com/my-org/my-repo ABC123XYZ... /var/actions-runner"
    exit 1
fi

REPO_URL="$1"
RUNNER_TOKEN="$2"
RUNNER_VERSION="2.317.0"

DEFAULT_DIR="$HOME/actions-runner"
if [ -n "$3" ]; then
    RUNNER_DIR="$3"
else
    read -p "Masukkan direktori instalasi runner [$DEFAULT_DIR]: " INPUT_DIR
    RUNNER_DIR="${INPUT_DIR:-$DEFAULT_DIR}"
fi

# Expand tilde ~ jika dimasukkan oleh pengguna
RUNNER_DIR="${RUNNER_DIR/#\~/$HOME}"

echo "Memulai setup GitHub Self-Hosted Runner di lokasi: $RUNNER_DIR"

# 1. Buat direktori runner jika belum ada
mkdir -p "$RUNNER_DIR"
cd "$RUNNER_DIR"

# 2. Download package runner jika belum ada
if [ ! -f "actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz" ]; then
    echo "Mengunduh GitHub Actions Runner v${RUNNER_VERSION}..."
    curl -o "actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz" -L "https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz"
fi

# 3. Ekstrak package
echo "Mengekstrak package runner..."
tar xzf "./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz"

# 4. Konfigurasi runner (Non-interactive)
echo "Mengkonfigurasi runner..."
./config.sh --url "$REPO_URL" --token "$RUNNER_TOKEN" --unattended --replace

# 5. Install & Jalankan sebagai systemd service
echo "Menginstall & menjalankan runner sebagai Systemd Service..."
sudo ./svc.sh install
sudo ./svc.sh start

# 6. Tampilkan status service
echo "Setup selesai! Status service runner:"
sudo ./svc.sh status
