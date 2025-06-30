# Install xournalpp (note-taking app)
if [ "$OMAKUB_OS_ID" = "debian" ]; then
  sudo $INSTALLER install -y xournalpp
else
  echo "Unsupported OS for xournalpp installation."
  exit 1
fi
