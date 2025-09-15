#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${REPO_URL:-https://github.com/powernetsrl/PowernetIot.git}"
APP_DIR="${APP_DIR:-/opt/powernet}"
SERVICE_NAME="${SERVICE_NAME:-powernet-backend}"
PORT="${PORT:-5000}"

echo "[1/6] Requisiti"
if command -v apt-get >/dev/null 2>&1; then
  sudo apt-get update -y
  sudo apt-get install -y git curl ca-certificates nginx
  if ! command -v node >/dev/null 2>&1; then
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt-get install -y nodejs
  fi
else
  echo "Solo Ubuntu/Debian con apt"; exit 1
fi

echo "[2/6] Codice ${REPO_URL} -> ${APP_DIR}"
if [ ! -d "${APP_DIR}" ]; then
  sudo mkdir -p "${APP_DIR}"
  sudo chown "$USER":"$USER" "${APP_DIR}"
  git clone "${REPO_URL}" "${APP_DIR}"
else
  cd "${APP_DIR}"
  git pull --rebase || true
fi

echo "[3/6] Backend deps"
cd "${APP_DIR}"
if [ -f "backend/package.json" ]; then
  pushd backend >/dev/null
  npm install --omit=dev
  popd >/dev/null
fi

echo "[4/6] systemd backend"
sudo bash -c "cat > /etc/systemd/system/${SERVICE_NAME}.service" <<EOF
[Unit]
Description=Powernet Backend
After=network.target

[Service]
Type=simple
User=${USER}
WorkingDirectory=${APP_DIR}/backend
Environment=PORT=${PORT}
ExecStart=/usr/bin/env node server.js
Restart=always
RestartSec=5
StandardOutput=append:${APP_DIR}/backend.out.log
StandardError=append:${APP_DIR}/backend.err.log

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable ${SERVICE_NAME}
sudo systemctl restart ${SERVICE_NAME}

echo "[5/6] Nginx (static + proxy /api)"
sudo mkdir -p /var/www/powernet
sudo cp -r "${APP_DIR}/frontend/." /var/www/powernet/
sudo bash -c 'cat > /etc/nginx/sites-available/powernet.conf' <<'NGX'
server {
  listen 80;
  server_name _;

  root /var/www/powernet;
  index index.html;

  location / {
    try_files $uri /index.html;
  }

  location /api/ {
    proxy_pass http://127.0.0.1:5000;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
  }
}
NGX
sudo ln -sf /etc/nginx/sites-available/powernet.conf /etc/nginx/sites-enabled/powernet.conf
sudo rm -f /etc/nginx/sites-enabled/default || true
sudo nginx -t && sudo systemctl reload nginx

echo "[6/6] Done"
echo "Frontend: http://$(hostname -I | awk '{print $1}')/"
echo "Health:   curl -fsS http://localhost:${PORT}/api/health || true"
