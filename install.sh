# Exit immediately if a command exits with a non-zero status and print errors clearly
set -eEuo pipefail

# Initialize for error reporting
current_command=""
last_command=""

# Improved error reporting: show the failed command and its exit code for easier troubleshooting
function omakub_error_trap {
  local exit_code=$?
  echo -e "\nDebian-Ok installation failed!\n  Command: $last_command\n  Exit code: $exit_code\n  You can retry by running: source ~/.local/share/debian-ok/install.sh"
  while true; do sleep 1; done
}
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'omakub_error_trap' ERR

# Check the distribution name and version and abort if incompatible

source ~/.local/share/debian-ok/install/check-version.sh
# Ask for required tools and user choices
echo "Get ready ..."
source ~/.local/share/debian-ok/install/terminal/required/app-gum.sh >/dev/null

source ~/.local/share/debian-ok/install/identification.sh

# Choose package installer (apt or nala)



if command -v nala >/dev/null 2>&1; then
  INSTALLER='nala'
else
  if gum confirm "Do you want to install nala? It works faster..."; then
    sudo apt update && sudo apt install -y nala
    INSTALLER='nala'
  else
    INSTALLER='apt'
  fi
fi
export INSTALLER

# Only install if running GNOME session
if [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]]; then
  # Prevent sleep/lock during installation
  gsettings set org.gnome.desktop.screensaver lock-enabled false
  gsettings set org.gnome.desktop.session idle-delay 0

  echo "Installing terminal and desktop tools..."

  # Install terminal tools
  source ~/.local/share/debian-ok/install/terminal.sh

  # Install desktop tools and tweaks
  source ~/.local/share/debian-ok/install/desktop.sh

  # Restore normal idle and lock settings
  gsettings set org.gnome.desktop.screensaver lock-enabled true
  gsettings set org.gnome.desktop.session idle-delay 300
else
  echo "Error: Debian-Ok must be installed from within a GNOME session."
  echo "Please log into GNOME and re-run this installer."
  exit 1
fi

# Note: For local .deb files, always use 'apt' (nala does not support local .deb installs)
