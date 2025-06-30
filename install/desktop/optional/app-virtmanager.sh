# Install virt-manager (Virtual Machine Manager) for Debian 12+

if [ "$OMAKUB_OS_ID" = "debian" ]; then
  sudo apt update && sudo apt install -y qemu-kvm libvirt-clients libvirt-daemon-system bridge-utils virtinst libvirt-daemon virt-manager
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
else
  echo "Error: virt-manager installation is only supported on Debian 12+."
  exit 1
fi

