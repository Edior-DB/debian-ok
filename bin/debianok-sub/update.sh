CHOICES=(
	"Debian.Ok        Update Omakub itself and run any migrations"
	"Ollama        Run LLMs, like Meta's Llama3, locally"
	"LazyGit       TUI for Git"
	"LazyDocker    TUI for Docker"
	"Neovim        Text editor that runs in the terminal"
	"Zellij        Adds panes, tabs, and sessions to the terminal"
	"<< Back       "
)

CHOICE=$(gum choose "${CHOICES[@]}" --height 10 --header "Update manually-managed applications")

if [[ "$CHOICE" == "<< Back"* ]] || [[ -z "$CHOICE" ]]; then
	# Don't update anything
	echo ""
else
	INSTALLER_1=$(echo "$CHOICE" | awk -F ' {2,}' '{print $1}' | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g')

	case "$INSTALLER_1" in
	"omakub") INSTALLER_FILE="$OMAKUB_PATH/bin/debianok-sub/migrate.sh" ;;
	"ollama") INSTALLER_FILE="$OMAKUB_PATH/install/terminal/optional/app-ollama.sh" ;;
	"lazygit"|"lazydocker"|"neovim"|"zellij") INSTALLER_FILE="$OMAKUB_PATH/install/terminal/optional/app-$INSTALLER_1.sh" ;;
	*) INSTALLER_FILE="$OMAKUB_PATH/install/terminal/app-$INSTALLER_1.sh" ;;
	esac

	source $INSTALLER_FILE && gum spin --spinner globe --title "Update completed!" -- sleep 3
fi

clear
source $OMAKUB_PATH/bin/debianok-sub/menu.sh
