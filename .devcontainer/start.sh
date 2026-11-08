#!/bin/bash
# start.sh — roda no postStartCommand
# Garante que o Linux KDE está sempre rodando (sobe mais rapido e é o default)
# Windows sobe somente se VPC_OS=windows

WORKDIR="${GITHUB_WORKSPACE:-/workspaces/virtual-pc}"
VPC_OS="${VPC_OS:-linux}"

echo "[start.sh] Verificando containers..."

# Sempre garante Linux na porta 6080
if ! docker ps | grep -q linux-desktop; then
  echo "[start.sh] Subindo Linux KDE (porta 6080)..."
  docker compose -f "${WORKDIR}/linux.yml" up -d 2>/dev/null || \
  docker compose -f linux.yml up -d 2>/dev/null || true
else
  echo "[start.sh] Linux KDE ja esta rodando."
fi

# Sobe Windows somente se pedido explicitamente
if [ "$VPC_OS" = "windows" ]; then
  if ! docker ps | grep -q "^windows"; then
    echo "[start.sh] Subindo Windows (porta 8006)..."
    docker compose -f "${WORKDIR}/windows.yml" up -d 2>/dev/null || \
    docker compose -f windows.yml up -d 2>/dev/null || true
  else
    echo "[start.sh] Windows ja esta rodando."
  fi
fi