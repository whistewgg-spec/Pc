#!/bin/bash
set -e

echo "================================================"
echo "   Virtual PC — Setup"
echo "================================================"

if ! docker compose version &>/dev/null 2>&1; then
  echo "[+] Instalando docker compose..."
  DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
  mkdir -p $DOCKER_CONFIG/cli-plugins
  curl -SL https://github.com/docker/compose/releases/download/v2.24.5/docker-compose-linux-x86_64 \
    -o $DOCKER_CONFIG/cli-plugins/docker-compose
  chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose
fi

echo "[+] Configurando Docker..."
sudo mkdir -p /tmp/docker-data
echo '{"data-root":"/tmp/docker-data"}' | sudo tee /etc/docker/daemon.json > /dev/null
sudo service docker restart 2>/dev/null || true
sleep 3

echo "[+] Baixando imagem Windows..."
docker pull dockurr/windows &

echo "[+] Baixando imagem Linux..."
docker pull lscr.io/linuxserver/webtop:ubuntu-kde &

wait
echo "[+] Imagens prontas."

WORKDIR="${GITHUB_WORKSPACE:-/workspaces/virtual-pc}"
echo "[+] Iniciando Windows..."
docker compose -f "${WORKDIR}/windows.yml" up -d 2>/dev/null || \
docker compose -f windows.yml up -d 2>/dev/null || true

echo "================================================"
echo " Pronto! Acessa a aba PORTS → porta 8006"
echo "================================================"