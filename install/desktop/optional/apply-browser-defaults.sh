#!/usr/bin/env bash
# Apply default settings for Brave and Firefox browsers

set -e

# Brave
if command -v brave-browser >/dev/null 2>&1; then
  BRAVE_PROFILE_DIR="$HOME/.config/BraveSoftware/Brave-Browser/Default"
  if [ -d "$BRAVE_PROFILE_DIR" ]; then
    jq -s '.[0] * .[1]' "$BRAVE_PROFILE_DIR/Preferences" "$DEBIANOK_PATH/install/desktop/optional/brave-defaults.json" > "$BRAVE_PROFILE_DIR/Preferences.tmp" && \
      mv "$BRAVE_PROFILE_DIR/Preferences.tmp" "$BRAVE_PROFILE_DIR/Preferences"
    echo "Brave default settings applied."
  fi
fi

# Firefox
if command -v firefox >/dev/null 2>&1; then
  FIREFOX_PROFILE=$(find "$HOME/.mozilla/firefox" -maxdepth 1 -type d -name "*.default*" | head -n 1)
  if [ -n "$FIREFOX_PROFILE" ]; then
    # Place settings in user.js for Firefox
    jq -r 'to_entries[] | "user_pref(\"browser." + .key + "\", " + (if (.value|type=="string") then "\""+.value+"\"" else (.value|tostring) end) + ");"' "$DEBIANOK_PATH/install/desktop/optional/firefox-defaults.json" > "$FIREFOX_PROFILE/user.js"
    echo "Firefox default settings applied."
  fi
fi
