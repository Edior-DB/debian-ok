#!/usr/bin/env bash
# Alacritty is a GPU-powered and highly extensible terminal. See https://alacritty.org/
# Install Alacritty
sudo $INSTALLER install -y alacritty
mkdir -p ~/.config/alacritty


# Fetch visuals (theme, font) from Chris Titus, but keep your own keybinds
curl -sSLo ~/.config/alacritty/alacritty-titus.toml "https://github.com/ChrisTitusTech/dwm-titus/raw/main/config/alacritty/alacritty.toml"
curl -sSLo ~/.config/alacritty/nordic.toml "https://github.com/ChrisTitusTech/dwm-titus/raw/main/config/alacritty/nordic.toml"
curl -sSLo ~/.config/alacritty/keybinds.toml "https://github.com/ChrisTitusTech/dwm-titus/raw/main/config/alacritty/keybinds.toml"

# Retain other custom settings
cp ~/.local/share/debian-ok/configs/alacritty/shared.toml ~/.config/alacritty/shared.toml
cp ~/.local/share/debian-ok/configs/alacritty/pane.toml ~/.config/alacritty/pane.toml
cp ~/.local/share/debian-ok/configs/alacritty/btop.toml ~/.config/alacritty/btop.toml
cp ~/.local/share/debian-ok/configs/alacritty/fonts/MesloLGS.toml ~/.config/alacritty/font.toml
cp ~/.local/share/debian-ok/configs/alacritty/font-size.toml ~/.config/alacritty/font-size.toml

# Always set shell.program to bash in shared.toml (do not reference zellij)
sed -i.bak 's/^program = ".*"/program = "bash"/' ~/.config/alacritty/shared.toml

# Migrate config format if needed
alacritty migrate 2>/dev/null || true
alacritty migrate -c ~/.config/alacritty/pane.toml 2>/dev/null || true
alacritty migrate -c ~/.config/alacritty/btop.toml 2>/dev/null || true

source ~/.local/share/debian-ok/install/desktop/set-alacritty-default.sh
