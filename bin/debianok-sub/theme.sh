THEME_NAMES=("Tokyo Night" "Catppuccin" "Nord" "Everforest" "Gruvbox" "Kanagawa" "Rose Pine")
THEME=$(gum choose "${THEME_NAMES[@]}" "<< Back" --header "Choose your theme" --height 10 | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g')

if [ -n "$THEME" ] && [ "$THEME" != "<<-back" ]; then
  # Determine config format based on Alacritty version
  ALACRITTY_VERSION=$(alacritty --version 2>/dev/null | awk '{print $2}')
  USE_YAML_CONFIG=false
  
  if [ -n "$ALACRITTY_VERSION" ]; then
    # Use YAML for Alacritty versions < 0.12, TOML for 0.12+
    if [ "$(printf '%s\n' "$ALACRITTY_VERSION" "0.12.0" | sort -V | head -n1)" = "$ALACRITTY_VERSION" ] && [ "$ALACRITTY_VERSION" != "0.12.0" ]; then
      USE_YAML_CONFIG=true
    fi
  else
    # Fallback: if we can't detect version, use Debian version as guide
    if [ "${DEBIANOK_DEBIAN_MAJOR:-}" = "12" ]; then
      USE_YAML_CONFIG=true
    fi
  fi
  
  # Copy Alacritty theme config based on detected version
  if [ "$USE_YAML_CONFIG" = "true" ]; then
    cp $OMAKUB_PATH/themes/$THEME/alacritty.yml ~/.config/alacritty/theme.yml
  else
    cp $OMAKUB_PATH/themes/$THEME/alacritty.toml ~/.config/alacritty/theme.toml
  fi
  
  cp $OMAKUB_PATH/themes/$THEME/zellij.kdl ~/.config/zellij/themes/$THEME.kdl
  sed -i "s/theme \".*\"/theme \"$THEME\"/g" ~/.config/zellij/config.kdl

  # Only update Neovim theme if Neovim config exists
  if [ -d "$HOME/.config/nvim/lua/plugins" ]; then
    cp $OMAKUB_PATH/themes/$THEME/neovim.lua ~/.config/nvim/lua/plugins/theme.lua
  fi

  if [ -f "$OMAKUB_PATH/themes/$THEME/btop.theme" ]; then
    cp $OMAKUB_PATH/themes/$THEME/btop.theme ~/.config/btop/themes/$THEME.theme
    sed -i "s/color_theme = \".*\"/color_theme = \"$THEME\"/g" ~/.config/btop/btop.conf
  else
    sed -i "s/color_theme = \".*\"/color_theme = \"Default\"/g" ~/.config/btop/btop.conf
  fi

  source $OMAKUB_PATH/themes/$THEME/gnome.sh
  source $OMAKUB_PATH/themes/$THEME/tophat.sh
  source $OMAKUB_PATH/themes/$THEME/vscode.sh

  # Forgo setting the Chrome theme until we might find a less disruptive way of doing it.
  # Having to quit Chrome, and all Chrome-based apps, is too much of an inposition.
  # source $OMAKUB_PATH/themes/$THEME/chrome.sh
fi

source $OMAKUB_PATH/bin/debianok-sub/menu.sh
