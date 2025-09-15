# PowernetIot

Breve descrizione del progetto.

## Prerequisiti
- Ubuntu 22.04+
- Docker & Docker Compose plugin
- Porte richieste aperte (es. 80/443/1883 per MQTT, se applicabile)

## Deploy manuale (SSH)
```bash
# sul server
sudo apt-get update -y
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker "$USER"
newgrp docker

# prima installazione
git clone https://github.com/powernetsrl/PowernetIot.git
cd PowernetIot

# avvio
docker compose up -d --build
```

## Deploy automatico (GitHub Actions)
1. Imposta i segreti nel repo:
   - `SSH_HOST`, `SSH_USER`, `SSH_KEY`, `PROJECT_PATH`, opzionale `SERVICE_NAME`.
2. Fai push su `main` e il workflow `Deploy to Ubuntu via SSH` pubblicherà automaticamente.

## Configurazione
- Variabili d'ambiente: crea `.env` (non committare) con le chiavi necessarie.

## Contribuire
Vedi `CODEOWNERS`, template issue/PR. Esegui i test con `ci/run_tests.sh` se presenti.
