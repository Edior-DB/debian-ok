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

# Determine config format based on Alacritty version
USE_YAML_CONFIG=false
if [ -n "$ALACRITTY_VERSION" ]; then
    # Use YAML for Alacritty versions < 0.12, TOML for 0.12+
    if version_lt "$ALACRITTY_VERSION" "0.12.0"; then
        USE_YAML_CONFIG=true
    fi
else
    # Fallback: if we can't detect version, use Debian version as guide
    if [ "${DEBIANOK_DEBIAN_MAJOR:-}" = "12" ]; then
        USE_YAML_CONFIG=true
    fi
fi

# Copy appropriate config files based on detected Alacritty version
if [ "$USE_YAML_CONFIG" = "true" ]; then
    # Use YAML configs for Alacritty v0.11 and below
    echo "Using YAML configuration for Alacritty v${ALACRITTY_VERSION:-unknown}"
    cp ~/.local/share/debian-ok/configs/alacritty.yml ~/.config/alacritty/alacritty.yml
    cp ~/.local/share/debian-ok/configs/alacritty/shared.yml ~/.config/alacritty/shared.yml
    cp ~/.local/share/debian-ok/configs/alacritty/pane.yml ~/.config/alacritty/pane.yml
    cp ~/.local/share/debian-ok/configs/alacritty/btop.yml ~/.config/alacritty/btop.yml
    cp ~/.local/share/debian-ok/configs/alacritty/fonts/MesloLGS.yml ~/.config/alacritty/font.yml
    cp ~/.local/share/debian-ok/configs/alacritty/font-size.yml ~/.config/alacritty/font-size.yml
    cp ~/.local/share/debian-ok/configs/alacritty/keybinds.yml ~/.config/alacritty/keybinds.yml
    cp ~/.local/share/debian-ok/themes/nord/alacritty.yml ~/.config/alacritty/theme.yml
elif [ "${DEBIANOK_DEBIAN_MAJOR:-}" = "13" ] && gum confirm "Use Chris Titus's Alacritty config?"; then
    # Debian 13+ with TOML - Chris Titus config option
    echo "Using Chris Titus TOML configuration for Alacritty v${ALACRITTY_VERSION:-unknown}"
    curl -sSLo ~/.config/alacritty/alacritty.toml "https://github.com/ChrisTitusTech/dwm-titus/raw/main/config/alacritty/alacritty.toml"
    curl -sSLo ~/.config/alacritty/nordic.toml "https://github.com/ChrisTitusTech/dwm-titus/raw/main/config/alacritty/nordic.toml"
    curl -sSLo ~/.config/alacritty/keybinds.toml "https://github.com/ChrisTitusTech/dwm-titus/raw/main/config/alacritty/keybinds.toml"
else
    # Use local TOML configs for Alacritty v0.12+
    echo "Using local TOML configuration for Alacritty v${ALACRITTY_VERSION:-unknown}"
    cp ~/.local/share/debian-ok/configs/alacritty.toml ~/.config/alacritty/alacritty.toml
    cp ~/.local/share/debian-ok/configs/alacritty/shared.toml ~/.config/alacritty/shared.toml
    cp ~/.local/share/debian-ok/configs/alacritty/pane.toml ~/.config/alacritty/pane.toml
    cp ~/.local/share/debian-ok/configs/alacritty/btop.toml ~/.config/alacritty/btop.toml
    cp ~/.local/share/debian-ok/configs/alacritty/fonts/MesloLGS.toml ~/.config/alacritty/font.toml
    cp ~/.local/share/debian-ok/configs/alacritty/font-size.toml ~/.config/alacritty/font-size.toml
    cp ~/.local/share/debian-ok/themes/nord/alacritty.toml ~/.config/alacritty/theme.toml
fi

# Migrate config format if needed (only for TOML configs)
if [ "$USE_YAML_CONFIG" != "true" ]; then
    alacritty migrate 2>/dev/null || true
    alacritty migrate -c ~/.config/alacritty/pane.toml 2>/dev/null || true
    alacritty migrate -c ~/.config/alacritty/btop.toml 2>/dev/null || true
fi

source ~/.local/share/debian-ok/install/desktop/set-alacritty-default.sh
