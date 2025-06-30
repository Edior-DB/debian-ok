# Configure the bash shell using Omakub defaults
[ -f "~/.bashrc" ] && mv ~/.bashrc ~/.bashrc.bak
cp ~/.local/share/debian-ok/configs/bashrc ~/.bashrc

# Load the PATH for use later in the installers
source ~/.local/share/debian-ok/defaults/bash/shell

[ -f "~/.inputrc" ] && mv ~/.inputrc ~/.inputrc.bak
# Configure the inputrc using Omakub defaults
cp ~/.local/share/debian-ok/configs/inputrc ~/.inputrc
