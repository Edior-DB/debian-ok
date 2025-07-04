#!/bin/bash
# Optional: lazydocker
if command -v lazydocker >/dev/null 2>&1; then
  LAZYDOCKER_VERSION=$(lazydocker --version 2>/dev/null | head -n 1)
  echo "lazydocker is already installed: $LAZYDOCKER_VERSION. Skipping install."
else
  # Install from GitHub releases as per official instructions
  cd /tmp || exit 1
  LAZYDOCKER_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  curl -sLo lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/latest/download/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz"
  tar -xf lazydocker.tar.gz lazydocker
  sudo install lazydocker /usr/local/bin
  rm lazydocker.tar.gz lazydocker
  cd - || true

  if command -v lazydocker >/dev/null 2>&1; then
    LAZYDOCKER_VERSION=$(lazydocker --version 2>/dev/null | head -n 1)
    echo "lazydocker installed successfully: $LAZYDOCKER_VERSION."
  else
    echo "lazydocker installation failed."; return 1;
  fi
fi
