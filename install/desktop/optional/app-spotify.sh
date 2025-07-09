#!/bin/bash
# Debian version check (only 12 supported, 13 not yet supported)
if [ "$OMAKUB_OS_VERSION_ID" = "13" ]; then
  echo "Debian 13 is not yet supported."
  exit 1
elif [ "$OMAKUB_OS_VERSION_ID" != "12" ]; then
  echo "Unsupported Debian version for this installer. Only Debian 12 is supported."
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
