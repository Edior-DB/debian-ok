# Check if pinta is installed before running --version
if command -v pinta >/dev/null 2>&1; then
  PINTA_VERSION=$(pinta --version 2>/dev/null | head -n 1)
  echo "Pinta is already installed: $PINTA_VERSION. Skipping install."
  exit 0
fi

if [ "$OMAKUB_OS_ID" = "debian" ]; then
  # Ensure flatpak is installed
  sudo $INSTALLER update -y
  sudo $INSTALLER install -y flatpak
  # Add flathub remote if not present
  if ! flatpak remote-list | grep -q flathub; then
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  fi
  # Install pinta via flatpak
  flatpak install -y flathub com.github.PintaProject.Pinta
else
  echo "Unsupported OS for Pinta installation."
  exit 1
fi
