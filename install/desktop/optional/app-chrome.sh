#!/bin/bash
# Debian version check (only 12 supported, 13 not yet supported)
if [ "$OMAKUB_OS_VERSION_ID" = "13" ]; then
  echo "Debian 13 is not yet supported."
  exit 1
elif [ "$OMAKUB_OS_VERSION_ID" != "12" ]; then
  echo "Unsupported Debian version for this installer. Only Debian 12 is supported."
  exit 1
fi
# Optional: Chrome browser
if command -v google-chrome >/dev/null 2>&1; then
  CHROME_VERSION=$(google-chrome --version 2>/dev/null | head -n 1)
  echo "Google Chrome is already installed: $CHROME_VERSION. Skipping install."
  exit 0
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
