#!/bin/bash
# Optional: zellij
if command -v zellij >/dev/null 2>&1; then
  ZELLIJ_VERSION=$(zellij --version 2>/dev/null | head -n 1)
  echo "zellij is already installed: $ZELLIJ_VERSION. Skipping install."
else
  cd /tmp
  wget -O zellij.tar.gz "https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz"
  tar -xf zellij.tar.gz zellij
  sudo install zellij /usr/local/bin
  rm zellij.tar.gz zellij
  cd -

  mkdir -p ~/.config/zellij/themes
  [ ! -f "$HOME/.config/zellij/config.kdl" ] && cp ~/.local/share/debian-ok/configs/zellij.kdl ~/.config/zellij/config.kdl
  cp ~/.local/share/debian-ok/themes/tokyo-night/zellij.kdl ~/.config/zellij/themes/tokyo-night.kdl
fi

# Ask user if they want to install kitty and link zellij to it
if gum confirm "Do you want to install and use kitty as the preferred terminal for zellij?"; then
  if ! command -v kitty >/dev/null 2>&1; then
    echo "Installing kitty..."
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
    [ -d ~/.local/kitty.app/bin ] && export PATH="$HOME/.local/kitty.app/bin:$PATH"
  fi
  # Apply Chris Titus's visuals for kitty
  if [ -d "$HOME/.config/kitty" ] && [ ! -d "$HOME/.config/kitty-bak" ]; then
    cp -r "$HOME/.config/kitty" "$HOME/.config/kitty-bak"
  fi
  mkdir -p "$HOME/.config/kitty/"
  curl -sSLo "$HOME/.config/kitty/kitty.conf" "https://github.com/ChrisTitusTech/dwm-titus/raw/main/config/kitty/kitty.conf"
  curl -sSLo "$HOME/.config/kitty/nord.conf" "https://github.com/ChrisTitusTech/dwm-titus/raw/main/config/kitty/nord.conf"
  mkdir -p ~/.local/bin
  echo -e '#!/bin/bash\nkitty zellij "$@"' > ~/.local/bin/zellij-in-kitty
  chmod +x ~/.local/bin/zellij-in-kitty
  echo "You can now run 'zellij-in-kitty' to launch zellij in kitty."
  else
  mkdir -p ~/.local/bin
  echo -e '#!/bin/bash\ngnome-terminal -- zellij "$@"' > ~/.local/bin/zellij-in-gnome-terminal
  chmod +x ~/.local/bin/zellij-in-gnome-terminal
  echo "You can now run 'zellij-in-gnome-terminal' to launch zellij in GNOME Terminal."
  fi

