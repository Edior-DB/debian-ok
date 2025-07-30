#!/bin/bash
# Debian version check (supports Debian 12 and 13+)
if [ "${DEBIANOK_DEBIAN_MAJOR:-0}" -lt 12 ]; then
  echo "Unsupported Debian version for this installer. Debian 12 or higher is required."
  exit 1
fi
# Install virt-manager (Virtual Machine Manager)
sudo $INSTALLER update
sudo $INSTALLER install -y qemu-kvm libvirt-clients libvirt-daemon-system bridge-utils virtinst libvirt-daemon virt-manager
echo "virt-manager and KVM packages installed successfully."

# Add user to libvirt and libvirt-qemu groups
sudo adduser "$USER" libvirt
sudo adduser "$USER" libvirt-qemu
echo "Added $USER to libvirt and libvirt-qemu groups. You may need to log out and log back in for group changes to take effect."

# Start and enable libvirtd service
sudo systemctl enable --now libvirtd
sudo systemctl status libvirtd --no-pager

# Start and autostart default network
sudo virsh net-start default || true
sudo virsh net-autostart default || true

# Load vhost_net module for better performance
sudo modprobe vhost_net
echo "vhost_net" | sudo tee -a /etc/modules

echo "virt-manager and KVM setup complete. You may need to reboot for all changes to take effect."
