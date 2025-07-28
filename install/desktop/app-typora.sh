#!/bin/bash
# Install Typora (markdown editor)
# Install Typora (markdown editor)
if ! command -v typora >/dev/null 2>&1; then
  wget -qO - https://typora.io/linux/public-key.asc | sudo tee /etc/apt/trusted.gpg.d/typora.asc >/dev/null
  echo 'deb https://typora.io/linux ./' | sudo tee /etc/apt/sources.list.d/typora.list >/dev/null
  sudo $INSTALLER update
  sudo $INSTALLER install -y typora || { echo "Failed to install Typora. Please check compatibility for your Debian version."; exit 1; }
else
  echo "typora is already installed, skipping."
fi

# Add iA Typora theme
mkdir -p ~/.config/Typora/themes
cp ~/.local/share/debian-ok/configs/typora/ia_typora.css ~/.config/Typora/themes/
cp ~/.local/share/debian-ok/configs/typora/ia_typora_night.css ~/.config/Typora/themes/
