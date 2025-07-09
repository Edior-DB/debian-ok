#!/bin/bash
# Debian version check (only 12 supported, 13 not yet supported)
if [ "$OMAKUB_OS_VERSION_ID" = "13" ]; then
  echo "Debian 13 is not yet supported."
  exit 1
elif [ "$OMAKUB_OS_VERSION_ID" != "12" ]; then
  echo "Unsupported Debian version for this installer. Only Debian 12 is supported."
  exit 1
fi

# Install Typora (markdown editor)
if ! command -v typora >/dev/null 2>&1; then
  wget -qO - https://typora.io/linux/public-key.asc | sudo tee /etc/apt/trusted.gpg.d/typora.asc
  sudo add-apt-repository -y 'deb https://typora.io/linux ./'
  sudo $INSTALLER update 
  sudo $INSTALLER install -y typora
else
  echo "typora is already installed, skipping."
fi

# Add iA Typora theme
mkdir -p ~/.config/Typora/themes
cp ~/.local/share/debian-ok/configs/typora/ia_typora.css ~/.config/Typora/themes/
cp ~/.local/share/debian-ok/configs/typora/ia_typora_night.css ~/.config/Typora/themes/
