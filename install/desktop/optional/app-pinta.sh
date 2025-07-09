#!/bin/bash
# Debian version check (only 12 supported, 13 not yet supported)
if [ "$OMAKUB_OS_VERSION_ID" = "13" ]; then
  echo "Debian 13 is not yet supported."
  exit 1
elif [ "$OMAKUB_OS_VERSION_ID" != "12" ]; then
  echo "Unsupported Debian version for this installer. Only Debian 12 is supported."
  exit 1
fi

# Check if pinta is installed before running --version
if command -v pinta >/dev/null 2>&1; then
  PINTA_VERSION=$(pinta --version 2>/dev/null | head -n 1)
  echo "Pinta is already installed: $PINTA_VERSION. Skipping install."
  exit 0
fi

if [ "$OMAKUB_OS_ID" = "debian" ]; then
  # Ensure flatpak is installed
  sudo $INSTALLER update
  sudo $INSTALLER install -y flatpak
  # Add flathub remote if not present
  if ! flatpak remote-list | grep -q flathub; then
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  fi
  # Install pinta via flatpak
  flatpak install -y flathub com.github.PintaProject.Pinta
else
  echo "Unsupported OS for Pinta installation."
  exit 1
fi
