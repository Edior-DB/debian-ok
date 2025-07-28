cd /tmp
ULVER=$(curl -s https://api.github.com/repos/Ulauncher/Ulauncher/releases/latest | grep 'tag_name' | cut -d"\"" -f4)
if [ -z "$ULVER" ]; then
  echo "Error: Could not determine latest Ulauncher version."; exit 1; fi
if ! wget -O ulauncher.deb "https://github.com/Ulauncher/Ulauncher/releases/download/$ULVER/ulauncher_${ULVER#v}_all.deb"; then
  echo "Error: Failed to download Ulauncher .deb."; exit 1; fi
if ! sudo apt install -y ./ulauncher.deb; then
  echo "Error: Failed to install Ulauncher .deb."; exit 1; fi
rm ulauncher.deb
cd -

# Start ulauncher to have it populate config before we overwrite
mkdir -p ~/.config/autostart/
cp ~/.local/share/debian-ok/configs/ulauncher.desktop ~/.config/autostart/ulauncher.desktop
gtk-launch ulauncher.desktop >/dev/null 2>&1
sleep 2 # ensure enough time for ulauncher to set defaults
cp ~/.local/share/debian-ok/configs/ulauncher.json ~/.config/ulauncher/settings.json
