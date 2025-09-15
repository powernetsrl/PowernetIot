# Powernet — Demo Full Project (Mock)

## Struttura
- `frontend/` SPA minima (React UMD + Babel) servita da Nginx
- `backend/` Node.js mock API
- `nginx/nginx.conf` per setup con Docker
- `scripts/install_from_github.sh` installer per Ubuntu/Debian (systemd + Nginx)
- `docker-compose.yml` avvio rapido con Docker

## Avvio rapido (Ubuntu/Debian, senza Docker)
```bash
# dopo aver caricato il repo in /opt/powernet oppure estratto lo zip
sudo bash scripts/install_from_github.sh
```

## Avvio con Docker
```bash
docker compose up --build -d
# frontend su :80, backend su :5000
```

## API mock
- GET `/api/health`
- GET `/api/version`
- GET `/api/tariffe`
- GET `/api/ha/states`
