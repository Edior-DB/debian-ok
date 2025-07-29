#!/bin/bash
# Create Kitty.desktop launcher in the user's local applications directory
mkdir -p "$HOME/.local/share/applications"
cat > "$HOME/.local/share/applications/Kitty.desktop" <<EOF
[Desktop Entry]
Name=Kitty
Comment=Fast, feature-rich, GPU based terminal emulator
Exec=kitty
Icon=$HOME/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png
Type=Application
Categories=System;TerminalEmulator;
StartupWMClass=kitty
EOF
