# Favorite apps for dock
apps=()

# Add desktop entries for installed apps
if command -v google-chrome >/dev/null 2>&1; then
	apps+=("google-chrome.desktop")
fi
if command -v firefox >/dev/null 2>&1; then
	apps+=("Firefox.desktop")
fi
if command -v brave-browser >/dev/null 2>&1; then
	apps+=("Brave.desktop")
fi
if command -v alacritty >/dev/null 2>&1; then
	apps+=("Alacritty.desktop")
fi
if command -v kitty >/dev/null 2>&1; then
	apps+=("zkitty.desktop")
fi
if command -v nvim >/dev/null 2>&1; then
	apps+=("Neovim.desktop")
fi
if command -v code >/dev/null 2>&1; then
	apps+=("code.desktop")
fi
if command -v whatsapp >/dev/null 2>&1; then
	apps+=("WhatsApp.desktop")
fi
if command -v signal-desktop >/dev/null 2>&1; then
	apps+=("signal-desktop.desktop")
fi
if command -v zoom >/dev/null 2>&1; then
	apps+=("Zoom.desktop")
fi
if command -v spotify >/dev/null 2>&1; then
	apps+=("spotify.desktop")
fi
if command -v steam >/dev/null 2>&1; then
	apps+=("steam.desktop")
fi
if command -v pinta >/dev/null 2>&1; then
	apps+=("pinta_pinta.desktop")
fi
if command -v obsidian >/dev/null 2>&1; then
	apps+=("md.obsidian.Obsidian.desktop")
fi
if command -v activity >/dev/null 2>&1; then
	apps+=("Activity.desktop")
fi
if command -v docker >/dev/null 2>&1; then
	apps+=("Docker.desktop")
fi
if command -v omakub >/dev/null 2>&1; then
	apps+=("Omakub.desktop")
fi
if command -v 1password >/dev/null 2>&1; then
	apps+=("1password.desktop")
fi
# GNOME settings and Nautilus are always present on GNOME
apps+=("org.gnome.Settings.desktop")
apps+=("org.gnome.Nautilus.desktop")
if command -v localsend >/dev/null 2>&1; then
	apps+=("localsend_app.desktop")
fi
if command -v kitty >/dev/null 2>&1; then
	apps+=("kitty.desktop")
fi

# Array to hold installed favorite apps
installed_apps=()

# Directory where .desktop files are typically stored
desktop_dirs=(
	"/var/lib/flatpak/exports/share/applications"
	"/usr/share/applications"
	"/usr/local/share/applications"
	"$HOME/.local/share/applications"
)

# Check if a .desktop file exists for each app
for app in "${apps[@]}"; do
	for dir in "${desktop_dirs[@]}"; do
		if [ -f "$dir/$app" ]; then
			installed_apps+=("$app")
			break
		fi
	done
done

# Convert the array to a format suitable for gsettings
favorites_list=$(printf "'%s'," "${installed_apps[@]}")
favorites_list="[${favorites_list%,}]"

# Set the favorite apps
gsettings set org.gnome.shell favorite-apps "$favorites_list"
