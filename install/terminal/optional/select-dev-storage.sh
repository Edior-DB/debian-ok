# Check if Docker is installed, install if missing
if ! command -v docker >/dev/null 2>&1; then
  echo "Docker not found. Installing Docker..."
  source "$OMAKUB_PATH/install/terminal/optional/docker.sh"
fi
# Ensure lazydocker is installed
source "$OMAKUB_PATH/install/terminal/optional/app-lazydocker.sh"

AVAILABLE_DBS=("MySQL" "Redis" "PostgreSQL")
dbs=$(gum choose "${AVAILABLE_DBS[@]}" --no-limit --height 5 --header "Select databases (runs in Docker)")

if [[ -n "$dbs" ]]; then
	for db in $dbs; do
		case $db in
		MySQL)
			sudo docker run -d --restart unless-stopped -p "127.0.0.1:3306:3306" --name=mysql8 -e MYSQL_ROOT_PASSWORD= -e MYSQL_ALLOW_EMPTY_PASSWORD=true mysql:8.4
			;;
		Redis)
			sudo docker run -d --restart unless-stopped -p "127.0.0.1:6379:6379" --name=redis redis:7
			;;
		PostgreSQL)
			sudo docker run -d --restart unless-stopped -p "127.0.0.1:5432:5432" --name=postgres16 -e POSTGRES_HOST_AUTH_METHOD=trust postgres:16
			;;
		esac
	done
fi
