#!/usr/bin/env bash
set -euo pipefail

# Richiede sudo
if [ "${EUID}" -ne 0 ]; then
  echo "Esegui come root: sudo $0"; exit 1
fi

apt-get update -y
curl -fsSL https://get.docker.com | sh
usermod -aG docker ${SUDO_USER:-$USER}

# Cartella di deploy
DEPLOY_DIR="/opt/powernetiot"
mkdir -p "$DEPLOY_DIR"
cd "$DEPLOY_DIR"

if [ ! -d .git ]; then
  git clone https://github.com/powernetsrl/PowernetIot.git .
fi

# Avvio servizi
if command -v docker &>/dev/null; then
  docker compose up -d --build
else
  echo "Docker non installato correttamente"; exit 2
fi

echo "Installazione completata. Ricorda di fare logout/login per attivare il gruppo docker."
