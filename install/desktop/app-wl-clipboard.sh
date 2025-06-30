# Provides a system clipboard interface for Neovim under Wayland

# Install wl-clipboard (Wayland clipboard tool)
if [ "$OMAKUB_OS_ID" = "debian" ]; then
  sudo dpkg -i wl-clipboard.deb
  sudo apt-get install -f
else
  echo "Unsupported OS for wl-clipboard installation."
  exit 1
fi
