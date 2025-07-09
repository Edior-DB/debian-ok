#!/bin/bash
# Debian version check (only 12 supported, 13 not yet supported)
if [ "$OMAKUB_OS_VERSION_ID" = "13" ]; then
  echo "Debian 13 is not yet supported."
  exit 1
elif [ "$OMAKUB_OS_VERSION_ID" != "12" ]; then
  echo "Unsupported Debian version for this installer. Only Debian 12 is supported."
  exit 1
fi
# Virtualbox allows you to run VMs for other flavors of Linux or even Windows
# See https://ubuntu.com/tutorials/how-to-run-ubuntu-desktop-on-a-virtual-machine-using-virtualbox#1-overview
# for a guide on how to run Ubuntu inside it.

# Install VirtualBox and extension pack
sudo $INSTALLER install -y virtualbox virtualbox-ext-pack
sudo usermod -aG vboxusers ${USER}
