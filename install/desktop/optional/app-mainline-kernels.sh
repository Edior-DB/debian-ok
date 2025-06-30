# Install mainline (kernel tool, Ubuntu only)
if [ "$OMAKUB_OS_ID" = "ubuntu" ]; then
  sudo add-apt-repository -y ppa:cappelikan/ppa
  sudo apt update -y
  sudo apt install -y mainline
else
  # Mainline kernel tool is not supported on Debian. This script is now a no-op.
  echo "Mainline kernel tool is only supported on Ubuntu. This fork is Debian-only."
  exit 0
fi
