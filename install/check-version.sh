#!/bin/bash

if [ ! -f /etc/os-release ]; then
  echo "$(tput setaf 1)Error: Unable to determine OS. /etc/os-release file not found."
  echo "Installation stopped."
  exit 1
fi

. /etc/os-release
# Set both DEBIANOK_OS_ID and OMAKUB_OS_ID for compatibility
export DEBIANOK_OS_ID="$ID"
export OMAKUB_OS_ID="$ID"
export DEBIANOK_OS_VERSION_ID="$VERSION_ID"
export OMAKUB_OS_VERSION_ID="$VERSION_ID"

# Check if running on Debian 12 or 13 only
if [ "$ID" = "debian" ]; then
  if [ "$VERSION_ID" = "12" ] || [ "$VERSION_ID" = "13" ]; then
    : # Supported
  else
    echo "$(tput setaf 1)Error: OS requirement not met"
    echo "You are currently running: $ID $VERSION_ID"
    echo "OS required: Debian 12 (bookworm) or Debian 13 (trixie)"
    echo "Installation stopped."
    exit 1
  fi
else
  echo "$(tput setaf 1)Error: OS requirement not met"
  echo "You are currently running: $ID $VERSION_ID"
  echo "OS required: Debian 12 (bookworm) or Debian 13 (trixie)"
  echo "Installation stopped."
  exit 1
fi

# Ensure GNU awk is installed and set as default on Debian
if [ "$OMAKUB_OS_ID" = "debian" ]; then
  if ! command -v gawk >/dev/null 2>&1; then
    echo "Installing GNU awk (gawk) for better compatibility..."
    sudo apt-get update && sudo apt-get install -y gawk
  fi
  # Set gawk as the default awk if not already
  if [ "$(readlink -f /usr/bin/awk)" != "/usr/bin/gawk" ]; then
    sudo update-alternatives --set awk /usr/bin/gawk
  fi
fi

# Check if running on x86
ARCH=$(uname -m)
if [ "$ARCH" != "x86_64" ] && [ "$ARCH" != "i686" ]; then
  echo "$(tput setaf 1)Error: Unsupported architecture detected"
  echo "Current architecture: $ARCH"
  echo "This installation is only supported on x86 architectures (x86_64 or i686)."
  echo "Installation stopped."
  exit 1
fi
source ~/.local/share/debian-ok/install/check-gnome.sh

sudo apt-get update >/dev/null

# Export Debian version for use in other scripts
export DEBIANOK_DEBIAN_MAJOR=$(echo $DEBIANOK_OS_VERSION_ID | cut -d. -f1)
export OMAKUB_DEBIAN_MAJOR=$(echo $OMAKUB_OS_VERSION_ID | cut -d. -f1)
export DEBIANOK_DEBIAN_MINOR=$(echo $DEBIANOK_OS_VERSION_ID | cut -d. -f2)
export OMAKUB_DEBIAN_MINOR=$(echo $OMAKUB_OS_VERSION_ID | cut -d. -f2)

