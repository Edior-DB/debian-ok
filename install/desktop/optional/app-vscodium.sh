#!/bin/bash
# Debian version check (supports Debian 12 and 13+)
if [ "${DEBIANOK_DEBIAN_MAJOR:-0}" -lt 12 ]; then
  echo "Unsupported Debian version for this installer. Debian 12 or higher is required."
  exit 1
fi

# Clean up any existing conflicting VSCodium GPG keys
[ -f /usr/share/keyrings/vscodium-archive-keyring.gpg ] && sudo rm -f /usr/share/keyrings/vscodium-archive-keyring.gpg
[ -f /etc/apt/keyrings/vscodium-archive-keyring.gpg ] && sudo rm -f /etc/apt/keyrings/vscodium-archive-keyring.gpg

# Remove any existing VSCodium sources to avoid conflicts
[ -f /etc/apt/sources.list.d/vscodium.list ] && sudo rm -f /etc/apt/sources.list.d/vscodium.list
[ -f /etc/apt/sources.list.d/vscodium.sources ] && sudo rm -f /etc/apt/sources.list.d/vscodium.sources
# Remove any other VSCodium related source files
if [ -d /etc/apt/sources.list.d/ ]; then
    sudo find /etc/apt/sources.list.d/ -name "*vscodium*" -delete 2>/dev/null || true
    sudo find /etc/apt/sources.list.d/ -name "*codium*" -delete 2>/dev/null || true
fi

cd /tmp
wget -qO- https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | gpg --dearmor > vscodium-archive-keyring.gpg
sudo install -D -o root -g root -m 644 vscodium-archive-keyring.gpg /etc/apt/keyrings/vscodium-archive-keyring.gpg
echo "deb [ signed-by=/etc/apt/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main" | sudo tee /etc/apt/sources.list.d/vscodium.list >/dev/null
rm -f vscodium-archive-keyring.gpg
cd -

# Clean APT cache to remove any cached repository data
sudo apt clean

sudo $INSTALLER update 
sudo $INSTALLER install -y codium

mkdir -p ~/.config/VSCodium/User
cp ~/.local/share/debian-ok/configs/vscode.json ~/.config/VSCodium/User/settings.json

# Install default supported themes
codium --install-extension enkia.tokyo-night
