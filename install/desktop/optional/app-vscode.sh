#!/bin/bash
# Debian version check (supports Debian 12 and 13+)
if [ "${DEBIANOK_DEBIAN_MAJOR:-0}" -lt 12 ]; then
  echo "Unsupported Debian version for this installer. Debian 12 or higher is required."
  exit 1
fi

# Check for VSCodium conflict - if installed, use Flatpak for VS Code
if command -v codium >/dev/null 2>&1 || [ -f /usr/bin/codium ] || [ -f /usr/local/bin/codium ]; then
    echo "VSCodium detected. Installing VS Code via Flatpak to avoid conflicts..."
    flatpak install -y flathub com.visualstudio.code
    
    # Create desktop entry for consistency
    mkdir -p ~/.local/share/applications
    cat > ~/.local/share/applications/code-flatpak.desktop << 'DESKTOP_EOF'
[Desktop Entry]
Name=Visual Studio Code (Flatpak)
Comment=Code Editing. Redefined.
GenericName=Text Editor
Exec=flatpak run com.visualstudio.code %F
Icon=com.visualstudio.code
Type=Application
StartupNotify=true
StartupWMClass=Code
Categories=Utility;TextEditor;Development;IDE;
MimeType=text/plain;inode/directory;application/x-code-workspace;
Actions=new-empty-window;
Keywords=vscode;

[Desktop Action new-empty-window]
Name=New Empty Window
Exec=flatpak run com.visualstudio.code --new-window %F
Icon=com.visualstudio.code
DESKTOP_EOF
    
    echo "VS Code installed via Flatpak due to VSCodium conflict"
    exit 0
fi

# Clean up any existing conflicting Microsoft GPG keys
[ -f /usr/share/keyrings/microsoft.gpg ] && sudo rm -f /usr/share/keyrings/microsoft.gpg
[ -f /etc/apt/keyrings/packages.microsoft.gpg ] && sudo rm -f /etc/apt/keyrings/packages.microsoft.gpg
[ -f /etc/apt/trusted.gpg.d/microsoft.gpg ] && sudo rm -f /etc/apt/trusted.gpg.d/microsoft.gpg

# Remove any existing VS Code sources to avoid conflicts
[ -f /etc/apt/sources.list.d/vscode.list ] && sudo rm -f /etc/apt/sources.list.d/vscode.list
[ -f /etc/apt/sources.list.d/vscode.sources ] && sudo rm -f /etc/apt/sources.list.d/vscode.sources
# Remove any other VS Code related source files
if [ -d /etc/apt/sources.list.d/ ]; then
    sudo find /etc/apt/sources.list.d/ -name "*vscode*" -delete 2>/dev/null || true
    sudo find /etc/apt/sources.list.d/ -name "*code*" -delete 2>/dev/null || true
fi

cd /tmp
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null
rm -f packages.microsoft.gpg
cd -

# Clean APT cache to remove any cached repository data
sudo apt clean

sudo $INSTALLER update 
sudo $INSTALLER install -y code

mkdir -p ~/.config/Code/User
cp ~/.local/share/debian-ok/configs/vscode.json ~/.config/Code/User/settings.json

# Install default supported themes
code --install-extension enkia.tokyo-night
