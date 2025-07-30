#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Make config dir if it doesn't exist
mkdir -p ~/.config/alacritty

# Check Alacritty version and choose configuration format
if command -v alacritty >/dev/null 2>&1; then
    ALACRITTY_VERSION=$(alacritty --version | cut -d' ' -f2)
    MAJOR_VERSION=$(echo "$ALACRITTY_VERSION" | cut -d'.' -f1)
    MINOR_VERSION=$(echo "$ALACRITTY_VERSION" | cut -d'.' -f2)
    
    # Alacritty v0.12+ uses TOML, v0.11 and earlier use YAML
    if [ "$MAJOR_VERSION" -eq 0 ] && [ "$MINOR_VERSION" -lt 12 ]; then
        USE_YAML_CONFIG=true
    else
        USE_YAML_CONFIG=false
    fi
else
    # Fallback to Debian version detection if alacritty not found
    if [ "${DEBIANOK_DEBIAN_MAJOR:-0}" -lt 13 ]; then
        USE_YAML_CONFIG=true
    else
        USE_YAML_CONFIG=false
    fi
fi

# Configure based on format
if [ "$USE_YAML_CONFIG" = "true" ]; then
    # Use YAML configs for Alacritty v0.11 and earlier
    echo "Using YAML configuration for Alacritty v${ALACRITTY_VERSION:-unknown}"
    cp ~/.local/share/debian-ok/configs/alacritty.yml ~/.config/alacritty/alacritty.yml
    cp ~/.local/share/debian-ok/configs/alacritty/shared.yml ~/.config/alacritty/shared.yml
    cp ~/.local/share/debian-ok/configs/alacritty/pane.yml ~/.config/alacritty/pane.yml
    cp ~/.local/share/debian-ok/configs/alacritty/btop.yml ~/.config/alacritty/btop.yml
    cp ~/.local/share/debian-ok/configs/alacritty/fonts/MesloLGS.yml ~/.config/alacritty/font.yml
    cp ~/.local/share/debian-ok/configs/alacritty/font-size.yml ~/.config/alacritty/font-size.yml
    cp ~/.local/share/debian-ok/configs/alacritty/keybinds.yml ~/.config/alacritty/keybinds.yml
    cp ~/.local/share/debian-ok/themes/nord/alacritty.yml ~/.config/alacritty/theme.yml
else
# Ask user about Chris Titus configs
if gum confirm "Do you want to use Chris Titus's Alacritty configuration? (Otherwise use local configs)"; then
    # Use Chris Titus TOML configs for Alacritty v0.12+
    echo "Using Chris Titus TOML configuration for Alacritty v${ALACRITTY_VERSION:-unknown}"
    curl -sSLo ~/.config/alacritty/alacritty.toml "https://github.com/ChrisTitusTech/dwm-titus/raw/main/config/alacritty/alacritty.toml"
    curl -sSLo ~/.config/alacritty/nordic.toml "https://github.com/ChrisTitusTech/dwm-titus/raw/main/config/alacritty/nordic.toml"
    curl -sSLo ~/.config/alacritty/keybinds.toml "https://github.com/ChrisTitusTech/dwm-titus/raw/main/config/alacritty/keybinds.toml"
else
    # Use local TOML configs for Alacritty v0.12+
    echo "Using local TOML configuration for Alacritty v${ALACRITTY_VERSION:-unknown}"
    
    # Ask user about custom keybindings
    if gum confirm "Do you want to use custom keybindings for Alacritty?"; then
        echo "Using configuration with custom keybindings..."
        cp ~/.local/share/debian-ok/configs/alacritty-with-keybinds.toml ~/.config/alacritty/alacritty.toml
        cp ~/.local/share/debian-ok/configs/alacritty/keybinds.toml ~/.config/alacritty/keybinds.toml
    else
        echo "Using standard configuration without custom keybindings..."
        cp ~/.local/share/debian-ok/configs/alacritty.toml ~/.config/alacritty/alacritty.toml
    fi
    
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
fi

source ~/.local/share/debian-ok/install/desktop/set-alacritty-default.sh
