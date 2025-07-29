choice=$(gum choose {10..18} "<< Back" --height 11 --header "Choose your terminal font size")

if [[ $choice =~ ^[0-9]+$ ]]; then
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
	
	# Update font-size config based on Alacritty version
	if [ "$USE_YAML_CONFIG" = "true" ]; then
		# Use portable sed for both GNU and BSD/macOS
		sed -i.bak -E "s/^\s*size: .*/size: $choice/" ~/.config/alacritty/font-size.yml
	else
		# Use portable sed for both GNU and BSD/macOS
		sed -i.bak -E "s/^\s*size = .*/size = $choice/" ~/.config/alacritty/font-size.toml
	fi
	source $OMAKUB_PATH/bin/debianok-sub/font-size.sh
else
	source $OMAKUB_PATH/bin/debianok-sub/font.sh
fi
