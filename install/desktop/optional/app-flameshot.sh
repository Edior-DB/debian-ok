#!/bin/bash
# Optional: Flameshot screenshot tool
if command -v flameshot >/dev/null 2>&1; then
  FLAMESHOT_VERSION=$(flameshot --version 2>/dev/null | head -n 1)
  echo "Flameshot is already installed: $FLAMESHOT_VERSION. Skipping install."
  exit 0
fi

sudo $INSTALLER update
if ! sudo $INSTALLER install -y flameshot; then
  echo "Error: Failed to install flameshot."; exit 1; fi

if command -v flameshot >/dev/null 2>&1; then
  FLAMESHOT_VERSION=$(flameshot --version 2>/dev/null | head -n 1)
  echo "Flameshot installed successfully: $FLAMESHOT_VERSION."
else
  echo "Flameshot installation failed."; exit 1;
fi
