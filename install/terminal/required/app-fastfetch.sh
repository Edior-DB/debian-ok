#!/usr/bin/env bash
# Install fastfetch (system info tool)
# Check if fastfetch is installed before running --version
if command -v fastfetch >/dev/null 2>&1; then
  FASTFETCH_VERSION=$(fastfetch --version 2>/dev/null | head -n 1)
  echo "Fastfetch is already installed: $FASTFETCH_VERSION. Skipping install."
else
  sudo $INSTALLER update
  # Download and install latest fastfetch .deb for amd64
  cd /tmp
  FASTFETCH_DEB_URL=$(curl -s https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest | grep browser_download_url | grep 'amd64.deb' | cut -d '"' -f 4 | head -n 1)
  if [ -z "$FASTFETCH_DEB_URL" ]; then
    echo "Could not find fastfetch .deb for Debian. Aborting."
    return 1
  fi
  wget -O fastfetch.deb "$FASTFETCH_DEB_URL"
  sudo apt install -y ./fastfetch.deb
  rm fastfetch.deb
  cd -

  # Only attempt to set configuration if fastfetch is not already set
  if [ ! -f "$HOME/.config/fastfetch/config.jsonc" ]; then
    # Use Omakub fastfetch config
    mkdir -p ~/.config/fastfetch
    cp ~/.local/share/debian-ok/configs/fastfetch.jsonc ~/.config/fastfetch/config.jsonc
  fi
fi
