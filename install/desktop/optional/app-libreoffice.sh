#!/bin/bash
# Optional: LibreOffice
if command -v libreoffice >/dev/null 2>&1; then
  LIBREOFFICE_VERSION=$(libreoffice --version 2>/dev/null | head -n 1)
  echo "LibreOffice is already installed: $LIBREOFFICE_VERSION. Skipping install."
  exit 0
fi
sudo $INSTALLER update
if ! sudo $INSTALLER install -y libreoffice; then
  echo "Error: Failed to install LibreOffice."; exit 1; fi
if command -v libreoffice >/dev/null 2>&1; then
  LIBREOFFICE_VERSION=$(libreoffice --version 2>/dev/null | head -n 1)
  echo "LibreOffice installed successfully: $LIBREOFFICE_VERSION."
else
  echo "LibreOffice installation failed."; exit 1;
fi
