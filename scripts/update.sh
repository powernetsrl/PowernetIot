#!/usr/bin/env bash
set -euo pipefail
APP_DIR="${APP_DIR:-/opt/powernet}"
SERVICE_NAME="${SERVICE_NAME:-powernet-backend}"
cd "${APP_DIR}"
git pull --rebase
pushd backend >/dev/null && npm ci --omit=dev || npm i --omit=dev; popd >/dev/null
sudo systemctl restart "${SERVICE_NAME}"
sudo rsync -a --delete frontend/ /var/www/powernet/
sudo systemctl reload nginx || true
echo "Aggiornato."
