set_font() {
	local font_name=$1
	local url=$2
	local file_type=$3
	local file_name="${font_name/ Nerd Font/}"

	if ! $(fc-list | grep -i "$font_name" >/dev/null); then
		cd /tmp
		wget -O "$file_name.zip" "$url"
		unzip "$file_name.zip" -d "$file_name"
		cp "$file_name"/*."$file_type" ~/.local/share/fonts
		rm -rf "$file_name.zip" "$file_name"
		fc-cache
		cd -
		clear
		source $OMAKUB_PATH/ascii.sh
	fi

	gsettings set org.gnome.desktop.interface monospace-font-name "$font_name 10"
	
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
	
	# Copy font config based on Alacritty version
	if [ "$USE_YAML_CONFIG" = "true" ]; then
		cp "$OMAKUB_PATH/configs/alacritty/fonts/$file_name.yml" ~/.config/alacritty/font.yml
	else
		cp "$OMAKUB_PATH/configs/alacritty/fonts/$file_name.toml" ~/.config/alacritty/font.toml
	fi
	#sed -i "s/\"editor.fontFamily\": \".*\"/\"editor.fontFamily\": \"$font_name\"/g" ~/.config/Code/User/settings.json
}

if [ "$#" -gt 1 ]; then
	choice=${!#}
else
	choice=$(gum choose "Cascadia Mono" "Fira Mono" "JetBrains Mono" "Meslo" "> Change size" "<< Back" --height 8 --header "Choose your programming font")
fi

case $choice in
"Cascadia Mono")
	set_font "CaskaydiaMono Nerd Font" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaMono.zip" "ttf"
	;;
"Fira Mono")
	set_font "FiraMono Nerd Font" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraMono.zip" "otf"
	;;
"JetBrains Mono")
	set_font "JetBrainsMono Nerd Font" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip" "ttf"
	;;
"Meslo")
	set_font "MesloLGS Nerd Font" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip" "ttf"
	;;
"> Change size")
	source $OMAKUB_PATH/bin/debianok-sub/font-size.sh
	exit
	;;
esac

source $OMAKUB_PATH/bin/debianok-sub/menu.sh
