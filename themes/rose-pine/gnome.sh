OMAKUB_THEME_COLOR="red"
DEBIANOK_THEME_COLOR="$OMAKUB_THEME_COLOR"
OMAKUB_THEME_BACKGROUND="rose-pine/background.jpg"
DEBIANOK_THEME_BACKGROUND="$OMAKUB_THEME_BACKGROUND"
source $OMAKUB_PATH/themes/set-gnome-theme.sh
gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
