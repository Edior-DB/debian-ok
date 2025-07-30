#!/bin/bash
# Debian version check (supports Debian 12 and 13+)
if [ "${DEBIANOK_DEBIAN_MAJOR:-0}" -lt 12 ]; then
  echo "Unsupported Debian version for this installer. Debian 12 or higher is required."
  exit 1
fi

cd /tmp
CHROME_DEB_URL="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
if ! wget -O chrome.deb "$CHROME_DEB_URL"; then
  echo "Error: Failed to download Chrome .deb."; exit 1; fi
if ! sudo apt install -y ./chrome.deb; then
  echo "Error: Failed to install Chrome .deb."; exit 1; fi
rm chrome.deb
cd -

if command -v google-chrome >/dev/null 2>&1; then
  CHROME_VERSION=$(google-chrome --version 2>/dev/null | head -n 1)
  echo "Google Chrome installed successfully: $CHROME_VERSION."
else
  echo "Google Chrome installation failed."; exit 1;
fi
