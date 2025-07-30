#!/bin/bash
# Debian version check (supports Debian 12 and 13+)
if [ "${DEBIANOK_DEBIAN_MAJOR:-0}" -lt 12 ]; then
  echo "Unsupported Debian version for this installer. Debian 12 or higher is required."
  exit 1
fi
# Install Signal Desktop
flatpak install -y flathub org.signal.Signal
