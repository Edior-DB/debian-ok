if ! dpkg -s gnome-tweaks >/dev/null 2>&1; then
  sudo apt-get update
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y gnome-tweaks
else
  echo "gnome-tweaks is already installed."
fi
