#!/bin/bash
# Debian version check (only 12 supported, 13 not yet supported)
if [ "$OMAKUB_OS_VERSION_ID" = "13" ]; then
  echo "Debian 13 is not yet supported."
  exit 1
elif [ "$OMAKUB_OS_VERSION_ID" != "12" ]; then
  echo "Unsupported Debian version for this installer. Only Debian 12 is supported."
  exit 1
fi
# Idempotent install: check if Minecraft Launcher is already installed
# Check if minecraft-launcher is installed before running --version
if command -v minecraft-launcher >/dev/null 2>&1; then
  MINECRAFT_VERSION=$(minecraft-launcher --version 2>/dev/null | head -n 1)
  echo "Minecraft Launcher is already installed: $MINECRAFT_VERSION. Skipping install."
  exit 0
fi

sudo $INSTALLER install -y openjdk-8-jdk

cd /tmp
wget https://launcher.mojang.com/download/Minecraft.deb
sudo apt install -y ./Minecraft.deb
rm Minecraft.deb
cd -
