#!/bin/bash
# Optional: lazygit
# Debian version check (only 12 supported, 13 not yet supported)
if [ "$OMAKUB_OS_VERSION_ID" = "13" ]; then
  echo "Debian 13 is not yet supported."
  exit 1
elif [ "$OMAKUB_OS_VERSION_ID" != "12" ]; then
  echo "Unsupported Debian version for this installer. Only Debian 12 is supported."
  exit 1
fi

if command -v lazygit >/dev/null 2>&1; then
  LAZYGIT_VERSION=$(lazygit --version 2>/dev/null | head -n 1)
  echo "lazygit is already installed: $LAZYGIT_VERSION. Skipping install."
else
  # Debian 12 method (as per GitHub repo)
  cd /tmp || exit 1
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit -D -t /usr/local/bin/
  rm lazygit.tar.gz lazygit
  mkdir -p ~/.config/lazygit/
  touch ~/.config/lazygit/config.yml
  cd - || true

  if command -v lazygit >/dev/null 2>&1; then
    LAZYGIT_VERSION=$(lazygit --version 2>/dev/null | head -n 1)
    echo "lazygit installed successfully: $LAZYGIT_VERSION."
  else
    echo "lazygit installation failed."; return 1;
  fi
fi
