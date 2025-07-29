#!/bin/bash
# Ensure bash-completion is installed
if ! [ -f /usr/share/bash-completion/bash_completion ]; then
  echo "bash-completion not found. Installing..."
  sudo $INSTALLER install -y bash-completion
else
  echo "bash-completion is already installed."
fi
