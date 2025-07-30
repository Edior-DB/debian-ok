#!/bin/bash
# Debian version check (supports Debian 12 and 13+)
if [ "${DEBIANOK_DEBIAN_MAJOR:-0}" -lt 12 ]; then
  echo "Unsupported Debian version for this installer. Debian 12 or higher is required."
  exit 1
fi
# Spotify for Debian 12 via Flatpak (recommended)
# Ensure flatpak is installed
sudo $INSTALLER install -y flatpak
# Add Flathub if not already present
if ! flatpak remote-list | grep -q flathub; then
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi
# Install Spotify
flatpak install -y flathub com.spotify.Client
