for script in ~/.local/share/debian-ok/applications/*.sh; do
  [ -f "$script" ] && source "$script"
done
