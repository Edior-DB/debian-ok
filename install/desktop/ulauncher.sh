cd /tmp
ULVER=$(curl -s https://api.github.com/repos/Ulauncher/Ulauncher/releases/latest | grep 'tag_name' | cut -d"\"" -f4)
if [ -z "$ULVER" ]; then
  echo "Error: Could not determine latest Ulauncher version."; exit 1; fi
if ! wget -O ulauncher.deb "https://github.com/Ulauncher/Ulauncher/releases/download/$ULVER/ulauncher_${ULVER#v}_all.deb"; then
  echo "Error: Failed to download Ulauncher .deb."; exit 1; fi
if ! sudo apt install -y ./ulauncher.deb; then
  echo "Error: Failed to install Ulauncher .deb."; exit 1; fi
rm ulauncher.deb
cd -

# Start ulauncher to have it populate config before we overwrite
mkdir -p ~/.config/autostart/
cp ~/.local/share/debian-ok/configs/ulauncher.desktop ~/.config/autostart/ulauncher.desktop

# Try multiple methods to start ulauncher and ensure it initializes properly
if command -v ulauncher >/dev/null 2>&1; then
    # Method 1: Direct execution (most reliable)
    ulauncher --hide-window &
    ULAUNCHER_PID=$!
    sleep 3 # Give ulauncher time to initialize
    
    # Check if ulauncher is running, if not try alternative methods
    if ! kill -0 $ULAUNCHER_PID 2>/dev/null; then
        echo "Direct launch failed, trying alternative methods..."
        
        # Method 2: Use nohup for better detachment
        nohup ulauncher --hide-window >/dev/null 2>&1 &
        sleep 2
        
        # Method 3: Use systemd user service if available
        if command -v systemctl >/dev/null 2>&1; then
            systemctl --user enable ulauncher.service 2>/dev/null || true
            systemctl --user start ulauncher.service 2>/dev/null || true
        fi
    fi
    
    # Wait a bit more to ensure config directory is created
    sleep 2
    
    # Copy settings after ulauncher has had time to create its config
    cp ~/.local/share/debian-ok/configs/ulauncher.json ~/.config/ulauncher/settings.json
else
    echo "Warning: ulauncher command not found in PATH"
fi
