#!/bin/bash
# Create Zkitty.desktop launcher in the user's local applications directory
mkdir -p "$HOME/.local/share/applications"
cat > "$HOME/.local/share/applications/zellij-in-kitty.desktop" <<EOF
[Desktop Entry]
Name=Zkitty
Comment=Fast, feature-rich, GPU based terminal emulator (with zellij)
Exec=zellij-in-kitty
Icon=$HOME/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png
Type=Application
Categories=System;TerminalEmulator;
StartupWMClass=kitty
EOF
