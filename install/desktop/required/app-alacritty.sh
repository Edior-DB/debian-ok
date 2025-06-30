#!/usr/bin/env bash
# Alacritty is a GPU-powered and highly extensible terminal. See https://alacritty.org/
# Install Alacritty
if [ "$DEBIANOK_OS_ID" = "debian" ]; then
  sudo apt install -y alacritty
else
  echo "Unsupported OS for Alacritty installation."
  exit 1
fi
mkdir -p ~/.config/alacritty
cp ~/.local/share/debian-ok/configs/alacritty.toml ~/.config/alacritty/alacritty.toml
cp ~/.local/share/debian-ok/configs/alacritty/shared.toml ~/.config/alacritty/shared.toml
# If zellij is not installed, set shell.program to bash in shared.toml
if ! command -v zellij >/dev/null 2>&1; then
  sed -i.bak 's/^program = "zellij"/program = "bash"/' ~/.config/alacritty/shared.toml
fi
cp ~/.local/share/debian-ok/configs/alacritty/pane.toml ~/.config/alacritty/pane.toml
cp ~/.local/share/debian-ok/configs/alacritty/btop.toml ~/.config/alacritty/btop.toml
cp ~/.local/share/debian-ok/themes/tokyo-night/alacritty.toml ~/.config/alacritty/theme.toml
cp ~/.local/share/debian-ok/configs/alacritty/fonts/CaskaydiaMono.toml ~/.config/alacritty/font.toml
cp ~/.local/share/debian-ok/configs/alacritty/font-size.toml ~/.config/alacritty/font-size.toml

# Migrate config format if needed
alacritty migrate 2>/dev/null || true
alacritty migrate -c ~/.config/alacritty/pane.toml 2>/dev/null || true
alacritty migrate -c ~/.config/alacritty/btop.toml 2>/dev/null || true

source ~/.local/share/debian-ok/install/desktop/set-alacritty-default.sh
