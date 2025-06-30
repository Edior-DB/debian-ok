# Needed for all installers
sudo apt update -y
sudo apt upgrade -y

# Install curl, git, unzip (core tools)
if [ "$DEBIANOK_OS_ID" = "debian" ]; then
  sudo apt install -y curl git unzip
else
  echo "Unsupported OS for core tools installation."
  exit 1
fi

# Run required terminal installers
for installer in ~/.local/share/debian-ok/install/terminal/required/*.sh; do
  echo "Running required terminal installer: $installer"
  bash "$installer"
done

# Run core terminal installers
for installer in ~/.local/share/debian-ok/install/terminal/*.sh; do
  echo "Running terminal installer: $installer"
  source $installer
done
