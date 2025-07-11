CHOICES=(
  "Dev Editor        Install alternative programming editors"
  "Docker            Install Docker and Docker Compose tools"
  "Dev Language      Install programming language environment"
  "Dev Database      Install development database in Docker"
  "1password         Manage your passwords securely across devices"
  "Audacity          Record and edit audio"
  "ASDControl        Set brightness on Apple Studio and XDR displays"
  "Chrome            Browser"
  "Dropbox           Sync files across computers with ease"
  "Gimp              Image manipulation tool ala Photoshop"
  "Geekbench         CPU benchmaking tool"
  "Mainline Kernels  Install newer Linux kernels than Ubuntu defaults"
  "Minecraft         Everyone's favorite blocky building game"
  "OBS Studio        Record screencasts with inputs from both display + webcam"
  "Ollama            Run LLMs, like Meta's Llama3, locally"
  "Retroarch         Play retro games"
  "Spotify           Stream music from the world's most popular service"
  "Steam             Play games from Valve's store"
  "Tailscale         Mesh VPN based on WireGuard and with Magic DNS"
  "VirtManager        Virtual machines to run Windows/Linux"
  "Zoom              Attend and host video chat meetings"
  "Web Apps          Install web apps with their own icon and shell"
  "> All             Re-run any of the default installers"
  "<< Back           "
)



# Auto-generated: load all optional installers from desktop/optional and terminal/optional, deduplicated
OPTIONAL_DESKTOP=( $(ls "$OMAKUB_PATH/install/desktop/optional/" | grep '^app-.*\\.sh$\|^select-.*\\.sh$' | sed 's/^app-//;s/^select-//;s/\\.sh$//;s/-/ /g') )
OPTIONAL_TERMINAL=( $(ls "$OMAKUB_PATH/install/terminal/optional/" | grep '^app-.*\\.sh$\|^select-.*\\.sh$' | sed 's/^app-//;s/^select-//;s/\\.sh$//;s/-/ /g') )

# Deduplicate and sort
ALL_OPTIONAL=("${OPTIONAL_DESKTOP[@]}" "${OPTIONAL_TERMINAL[@]}")
ALL_OPTIONAL_SORTED=( $(printf "%s\n" "${ALL_OPTIONAL[@]}" | awk '!seen[$0]++' | sort) )

for opt in "${ALL_OPTIONAL_SORTED[@]}"; do
  # Determine source for label
  if [[ " ${OPTIONAL_DESKTOP[*]} " == *" $opt "* ]]; then
    CHOICES+=("$(tr '[:lower:]' '[:upper:]' <<< ${opt:0:1})${opt:1}        (Desktop optional)")
  elif [[ " ${OPTIONAL_TERMINAL[*]} " == *" $opt "* ]]; then
    CHOICES+=("$(tr '[:lower:]' '[:upper:]' <<< ${opt:0:1})${opt:1}        (Terminal optional)")
  fi
  # If in both, only Desktop label will show (first match)
done

CHOICE=$(gum choose "${CHOICES[@]}" --height 25 --header "Install application")

if [[ "$CHOICE" == "<< Back"* ]] || [[ -z "$CHOICE" ]]; then
  echo ""
elif [[ "$CHOICE" == "> All"* ]]; then
  INSTALLER_FILE=$(gum file $OMAKUB_PATH/install)
  if [[ -n "$INSTALLER_FILE" ]]; then
    gum confirm "Run installer?" &&
    source "$INSTALLER_FILE" &&
    gum spin --spinner globe --title "Install completed!" -- sleep 3
  fi
else
  INSTALLER_1=$(echo "$CHOICE" | awk -F ' {2,}' '{print $1}' | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g')
  case "$INSTALLER_1" in
    "dev-editor") INSTALLER_FILE="$OMAKUB_PATH/bin/debianok-sub/install-dev-editor.sh" ;;
    "web-apps") INSTALLER_FILE="$OMAKUB_PATH/install/desktop/optional/select-web-apps.sh" ;;
    "dev-language") INSTALLER_FILE="$OMAKUB_PATH/install/terminal/optional/select-dev-language.sh" ;;
    "dev-database") INSTALLER_FILE="$OMAKUB_PATH/install/terminal/optional/select-dev-storage.sh" ;;
    "docker") INSTALLER_FILE="$OMAKUB_PATH/install/terminal/optional/docker.sh" ;;
    "ollama") INSTALLER_FILE="$OMAKUB_PATH/install/terminal/optional/app-ollama.sh" ;;
    "tailscale") INSTALLER_FILE="$OMAKUB_PATH/install/terminal/optional/app-tailscale.sh" ;;
    "geekbench") INSTALLER_FILE="$OMAKUB_PATH/install/terminal/optional/app-geekbench.sh" ;;
    *) INSTALLER_FILE="$OMAKUB_PATH/install/desktop/optional/app-$INSTALLER_1.sh" ;;
  esac

  # Try both locations for the installer script
  if [ -f "$OMAKUB_PATH/install/desktop/optional/app-$INSTALLER_1.sh" ]; then
    INSTALLER_FILE="$OMAKUB_PATH/install/desktop/optional/app-$INSTALLER_1.sh"
  elif [ -f "$OMAKUB_PATH/install/terminal/optional/app-$INSTALLER_1.sh" ]; then
    INSTALLER_FILE="$OMAKUB_PATH/install/terminal/optional/app-$INSTALLER_1.sh"
  fi

  if [ -f "$INSTALLER_FILE" ]; then
    echo "Running installer: $INSTALLER_FILE"
    source "$INSTALLER_FILE" && gum spin --spinner globe --title "Install completed!" -- sleep 3
  else
    echo "Installer $INSTALLER_FILE not found."
  fi
fi

clear
source $OMAKUB_PATH/bin/debianok-sub/menu.sh
