#!/bin/bash
# Debian version check (only 12 supported, 13 not yet supported)
if [ "$OMAKUB_OS_VERSION_ID" = "13" ]; then
  echo "Debian 13 is not yet supported."
  exit 1
elif [ "$OMAKUB_OS_VERSION_ID" != "12" ]; then
  echo "Unsupported Debian version for this installer. Only Debian 12 is supported."
  exit 1
fi
# Optional: LibreOffice
if command -v libreoffice >/dev/null 2>&1; then
  LIBREOFFICE_VERSION=$(libreoffice --version 2>/dev/null | head -n 1)
  echo "LibreOffice is already installed: $LIBREOFFICE_VERSION. Skipping install."
  exit 0
fi

if [ "$OMAKUB_OS_ID" = "debian" ]; then
  sudo $INSTALLER update
  if ! sudo $INSTALLER install -y libreoffice; then
    echo "Error: Failed to install LibreOffice."; exit 1; fi
else
  echo "Unsupported OS for LibreOffice installation."; exit 1;
fi

if command -v libreoffice >/dev/null 2>&1; then
  LIBREOFFICE_VERSION=$(libreoffice --version 2>/dev/null | head -n 1)
  echo "LibreOffice installed successfully: $LIBREOFFICE_VERSION."
else
  echo "LibreOffice installation failed."; exit 1;
fi
