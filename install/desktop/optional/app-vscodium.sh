#!/bin/bash
# Install VSCodium on Debian-based systems
set -e

cd /tmp
wget -qO- https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | gpg --dearmor > vscodium-archive-keyring.gpg
sudo install -D -o root -g root -m 644 vscodium-archive-keyring.gpg /usr/share/keyrings/vscodium-archive-keyring.gpg
echo "deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main" | sudo tee /etc/apt/sources.list.d/vscodium.list >/dev/null
rm -f vscodium-archive-keyring.gpg
cd -

sudo $INSTALLER update 
sudo $INSTALLER install -y codium

mkdir -p ~/.config/VSCodium/User
cp ~/.local/share/debian-ok/configs/vscode.json ~/.config/VSCodium/User/settings.json

# Install default supported themes
codium --install-extension enkia.tokyo-night
