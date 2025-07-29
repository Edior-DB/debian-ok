#!/usr/bin/env bash
# Alacritty is a GPU-powered and highly extensible terminal. See https://alacritty.org/
# Install Alacritty

sudo $INSTALLER install -y alacritty
mkdir -p ~/.config/alacritty

# Detect Alacritty version
ALACRITTY_VERSION=$(alacritty --version 2>/dev/null | awk '{print $2}')

# Function to compare versions
version_lt() {
    [ "$1" = "$2" ] && return 1
    [ "$(printf '%s\n' "$1" "$2" | sort -V | head -n1)" = "$1" ]
}



if gum confirm "Use Chris Titus's Alacritty config?"; then
    # Use old config for Alacritty < 0.14.0, new config for >= 0.14.0
    if version_lt "$ALACRITTY_VERSION" "0.14.0"; then
        # Old config (pre-migration)
        curl -sSLo ~/.config/alacritty/alacritty.toml "https://github.com/ChrisTitusTech/dwm-titus/raw/bc9ad512674668b7713ec134d08d63200be8fcee/config/alacritty/alacritty.toml"
        curl -sSLo ~/.config/alacritty/nordic.toml "https://github.com/ChrisTitusTech/dwm-titus/raw/bc9ad512674668b7713ec134d08d63200be8fcee/config/alacritty/nordic.toml"
        curl -sSLo ~/.config/alacritty/keybinds.toml "https://github.com/ChrisTitusTech/dwm-titus/raw/bc9ad512674668b7713ec134d08d63200be8fcee/config/alacritty/keybinds.toml"
    else
        # New config (main branch)
        curl -sSLo ~/.config/alacritty/alacritty.toml "https://github.com/ChrisTitusTech/dwm-titus/raw/main/config/alacritty/alacritty.toml"
        curl -sSLo ~/.config/alacritty/nordic.toml "https://github.com/ChrisTitusTech/dwm-titus/raw/main/config/alacritty/nordic.toml"
        curl -sSLo ~/.config/alacritty/keybinds.toml "https://github.com/ChrisTitusTech/dwm-titus/raw/main/config/alacritty/keybinds.toml"
    fi
else
    # Use local configs (main)
    cp ~/.local/share/debian-ok/configs/alacritty.toml ~/.config/alacritty/alacritty.toml
    cp ~/.local/share/debian-ok/configs/alacritty/shared.toml ~/.config/alacritty/shared.toml
    cp ~/.local/share/debian-ok/configs/alacritty/pane.toml ~/.config/alacritty/pane.toml
    cp ~/.local/share/debian-ok/configs/alacritty/btop.toml ~/.config/alacritty/btop.toml
    cp ~/.local/share/debian-ok/configs/alacritty/fonts/MesloLGS.toml ~/.config/alacritty/font.toml
    cp ~/.local/share/debian-ok/configs/alacritty/font-size.toml ~/.config/alacritty/font-size.toml
    cp ~/.local/share/debian-ok/themes/nord/alacritty.toml ~/.config/alacritty/theme.toml
fi

# Always set shell.program to bash in shared.toml (do not reference zellij)
sed -i.bak 's/^program = ".*"/program = "bash"/' ~/.config/alacritty/shared.toml

# Migrate config format if needed
alacritty migrate 2>/dev/null || true
alacritty migrate -c ~/.config/alacritty/pane.toml 2>/dev/null || true
alacritty migrate -c ~/.config/alacritty/btop.toml 2>/dev/null || true

source ~/.local/share/debian-ok/install/desktop/set-alacritty-default.sh
