#!/bin/bash
# Debian version check (supports Debian 12 and 13+)
if [ "${DEBIANOK_DEBIAN_MAJOR:-0}" -lt 12 ]; then
  echo "Unsupported Debian version for this installer. Debian 12 or higher is required."
  exit 1
fi
# Install asdcontrol
git clone https://github.com/nikosdion/asdcontrol.git /tmp/asdcontrol
cd /tmp/asdcontrol
make
sudo make install
cd -
rm -rf /tmp/asdcontrol

# Setup sudo-less controls
echo 'KERNEL=="hiddev*", ATTRS{idVendor}=="05ac", ATTRS{idProduct}=="9243", GROUP="users", OWNER="root", MODE="0660"' | sudo tee /etc/udev/rules.d/50-apple-xdr.rules >/dev/null
echo 'KERNEL=="hiddev*", ATTRS{idVendor}=="05ac", ATTRS{idProduct}=="1114", GROUP="users", OWNER="root", MODE="0660"' | sudo tee /etc/udev/rules.d/50-apple-studio.rules >/dev/null
sudo udevadm control --reload-rules

# Reboot to pickup changes
gum confirm "Ready to reboot for brightness controls to be available?" && sudo reboot
