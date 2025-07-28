#!/bin/bash
# Create Zkitty.desktop launcher in the user's local applications directory
mkdir -p "$HOME/.local/share/applications"
cat > "$HOME/.local/share/applications/Zkitty.desktop" <<EOF
[Desktop Entry]
Name=Zkitty
Comment=Fast, feature-rich, GPU based terminal emulator (with zellij)
Exec=zkitty
Icon=kitty
Type=Application
Categories=System;TerminalEmulator;
StartupWMClass=kitty
EOF
