choice=$(gum choose {10..18} "<< Back" --height 11 --header "Choose your terminal font size")

if [[ $choice =~ ^[0-9]+$ ]]; then
	# Update font-size config based on Debian version
	if [ "${DEBIANOK_DEBIAN_MAJOR:-}" = "12" ]; then
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
