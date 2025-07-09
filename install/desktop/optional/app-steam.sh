#!/bin/bash
# Debian version check (only 12 supported, 13 not yet supported)
if [ "$OMAKUB_OS_VERSION_ID" = "13" ]; then
  echo "Debian 13 is not yet supported."
  exit 1
elif [ "$OMAKUB_OS_VERSION_ID" != "12" ]; then
  echo "Unsupported Debian version for this installer. Only Debian 12 is supported."
  exit 1
fi

# Idempotent install: check if Steam is already installed
if command -v steam >/dev/null 2>&1; then
  STEAM_VERSION=$(steam --version 2>/dev/null | head -n 1)
  echo "Steam is already installed: $STEAM_VERSION. Skipping install."
  exit 0
fi

# Play games from https://store.steampowered.com/
cd /tmp
wget https://cdn.akamai.steamstatic.com/client/installer/steam.deb
sudo apt install -y ./steam.deb
rm steam.deb
cd -
