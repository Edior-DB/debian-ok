# Debian-Ok launcher (no dependency check needed)
mkdir -p ~/.local/share/applications
if [ ! -w ~/.local/share/applications ]; then
  echo "Error: Cannot write to ~/.local/share/applications."
else
  # Create the launcher
  cat <<EOF >~/.local/share/applications/debian-ok.desktop
[Desktop Entry]
Version=1.0
Name=Debian-Ok
Comment=Debian-Ok Controls
Exec=alacritty --config-file /home/$USER/.config/alacritty/pane.toml --class=DebianOk --title=DebianOk -e $HOME/.local/share/debian-ok/bin/debian.ok
Terminal=false
Type=Application
Icon=/home/$USER/.local/share/debian-ok/applications/icons/Debian-Ok.png
Categories=GTK;
StartupNotify=false
EOF
fi
