# Needed for all installers
sudo $INSTALLER update 
sudo $INSTALLER upgrade -y

# Install curl, git, unzip (core tools)

sudo $INSTALLER install -y curl git unzip

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
