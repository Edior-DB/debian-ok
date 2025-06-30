set -euo pipefail

# Set and export DEBIANOK_PATH for consistency
export DEBIANOK_PATH="$HOME/.local/share/debian-ok"
# Mirror for legacy compatibility
export OMAKUB_PATH="$DEBIANOK_PATH"

# Prevent running as root
if [[ $EUID -eq 0 ]]; then
    echo "$(tput setaf 1)Error: Do not run this installer as root. Please run as a regular user with sudo privileges."
    echo "Installation stopped."
    exit 1
fi

# Early checks for required commands and OS
if ! command -v sudo >/dev/null 2>&1; then
    echo "$(tput setaf 1)Error: 'sudo' command not found. Please install sudo and ensure it is in your PATH."
    echo "Installation stopped."
    exit 1
fi

# Use a here-document for ASCII art (bash/pipe-safe)
ascii_art="""
 ____        _     _             ____        _    
|  _ \\  ___| |__ (_)_ __   __ _|  _ \\  ___| | __
| | | |/ _ \\ '_ \\| | '_ \\ / _ | | | |/ _ \\ |/ /
| |_| |  __/ | | | | | | | (_| | |_| |  __/   < 
|____/ \\___|_| |_|_|_| |_|\\__, |____/ \\___|_|\\_\\
                              |___/                
"""

echo -e "$ascii_art"
echo "=> Debian-Ok is for fresh Debian 12+ (Bookworm or newer) installations only!"
echo -e "\nPress Enter to begin installation, or abort with Ctrl+C."
read -r

if ! groups "$USER" | grep -qw sudo; then
    echo "$(tput setaf 1)Error: Your user ($USER) is not in the 'sudo' group."
    echo "On Debian 12+, you must add your user to the 'sudo' group and re-login before running this installer."
    echo "Switch to root with: su -"
    echo "Then run: /sbin/usermod -aG sudo <your-username>"
    echo "(Replace <your-username> with your actual username, e.g. '$(logname)' if unsure)"
    echo "After that, log out and log back in as your user, then re-run the installer."
    echo "For some weird reason, you might also need to reboot your system."
    echo "Installation stopped."
    exit 1
fi

sudo apt-get install -y git >/dev/null

echo "Cloning Debian-Ok..."
rm -rf "$DEBIANOK_PATH"
git clone https://github.com/Edior-DB/debian-ok.git "$DEBIANOK_PATH" >/dev/null
if [[ ${DEBIANOK_REF:-master} != "master" ]]; then
    cd "$DEBIANOK_PATH"
    git fetch origin "${DEBIANOK_REF:-stable}" && git checkout "${DEBIANOK_REF:-stable}"
    cd -
fi

echo "Installation starting..."
source "$DEBIANOK_PATH/install.sh"
