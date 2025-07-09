#!/bin/bash
# Debian version check (only 12 supported, 13 not yet supported)
if [ "$OMAKUB_OS_VERSION_ID" = "13" ]; then
  echo "Debian 13 is not yet supported."
  exit 1
elif [ "$OMAKUB_OS_VERSION_ID" != "12" ]; then
  echo "Unsupported Debian version for this installer. Only Debian 12 is supported."
  exit 1
fi

# Idempotent install: check if already installed
# Check if rubymine is installed before running --version
if command -v rubymine >/dev/null 2>&1; then
  RUBYMINE_VERSION=$(rubymine --version 2>/dev/null | head -n 1)
  echo "RubyMine is already installed: $RUBYMINE_VERSION. Skipping install."
  exit 0
fi

# Download and extract latest RubyMine tarball from JetBrains
cd /tmp
LATEST_RM_URL=$(curl -s https://data.services.jetbrains.com/products/releases?code=RM\&latest=true\&type=release | grep -o 'https://download.jetbrains.com/.*linux.*.tar.gz' | head -n 1)
if [ -z "$LATEST_RM_URL" ]; then
  echo "Could not find RubyMine tarball. Aborting."
  exit 1
fi
wget -O rubymine.tar.gz "$LATEST_RM_URL"
tar -xzf rubymine.tar.gz
RMDIR=$(tar -tf rubymine.tar.gz | head -1 | cut -f1 -d"/")
sudo mv "$RMDIR" /opt/
sudo ln -sf "/opt/$RMDIR/bin/rubymine.sh" /usr/local/bin/rubymine
rm rubymine.tar.gz
cd -
