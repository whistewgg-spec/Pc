#!/bin/bash
set -e
echo "================================================"
echo "   Virtual PC — Setup"
echo "================================================"

# Instala apps extras no desktop
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -y -qq \
  firefox \
  mousepad \
  xfce4-terminal \
  htop \
  curl wget git \
  2>/dev/null || true

echo "================================================"
echo " Desktop pronto! Acessa a porta 6080"
echo "================================================"