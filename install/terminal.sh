# Needed for all installers
sudo $INSTALLER update 
sudo $INSTALLER upgrade -y

# Install curl, git, unzip (core tools)
if [ "$DEBIANOK_OS_ID" = "debian" ] || [ "$OMAKUB_OS_ID" = "debian" ]; then
  sudo $INSTALLER install -y curl git unzip
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
