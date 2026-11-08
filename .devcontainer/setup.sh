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

WORKDIR="${GITHUB_WORKSPACE:-/workspaces/virtual-pc}"

echo "[+] Baixando imagem Linux KDE..."
docker pull lscr.io/linuxserver/webtop:ubuntu-kde

echo "[+] Iniciando Linux KDE na porta 6080..."
docker compose -f "${WORKDIR}/linux.yml" up -d 2>/dev/null || \
docker compose -f linux.yml up -d 2>/dev/null || true

echo "[+] Baixando imagem Windows em background..."
docker pull dockurr/windows &

echo "================================================"
echo " Linux KDE pronto na porta 6080!"
echo " Windows estará disponivel em ~15-20 min na porta 8006"
echo "================================================"