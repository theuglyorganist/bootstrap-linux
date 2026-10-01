cp "$scriptDir"/dots/.bashrc.backup "$scriptDir"/dots/.bashrc

if [[ -d "$scriptDir/neofetch" ]]; then
    echo "Neofetch directory already exist, skipping installation."
else
    echo "Installing neofetch..."
    git clone https://github.com/dylanaraps/neofetch "$scriptDir"/
    cd "$scriptDir"/neofetch && sudo make install
    cd "$scriptDir" && rm -rf "$scriptDir"/neofetch
fi

if [[ "$PM" == "dnf" ]]; then
    echo "PS1='\[\e[1;36m\]┌─ \[\e[1;35m\] \[\e[1;37m\]\w\n\[\e[1;36m\]╰─› \[\e'" >> "$scriptDir"/dots/.bashrc

elif [[ "$PM" == "pacman" ]]; then
    echo "PS1='\[\e[1;36m\]┌─ \[\e[1;35m\]󰣇 \[\e[1;37m\]\w\n\[\e[1;36m\]╰─› \[\e'" >> "$scriptDir"/dots/.bashrc

elif [[ "$PM" == "apt" ]]; then
    echo "PS1='\[\e[1;36m\]┌─ \[\e[1;35m\] \[\e[1;37m\]\w\n\[\e[1;36m\]╰─› \[\e'" >> "$scriptDir"/dots/.bashrc
fi

mkdir -p $HOME/.config/neofetch/
cp "$scriptDir"/dots/neofetch/config.conf $HOME/.config/neofetch/

mkdir -p $HOME/.config/ghostty
cp "$scriptDir"/dots/ghostty/config.ghostty $HOME/.config/ghostty

cp "$scriptDir"/dots/.bashrc $HOME/

if [[ "$fullSetup" == "n" ]]; then
    gitIdentity=$(validation "Configure Git identity? [Y/n] ")
fi
if [[ "$gitIdentity" == "y" ||  "$fullSetup" == "y" ]]; then
    read -rp "Git username: " git_name
    read -rp "Git email: " git_email
    git config --global user.name "$git_name"
    git config --global user.email "$git_email"
fi
git config --global core.editor "nano"

echo "Moving scripts to path..."
sudo mkdir -p /usr/bin/scripts
echo 'export PATH="$PATH:/usr/bin/scripts"' >> "$HOME/.bashrc" 
sudo cp "$scriptDir"/scripts/* /usr/bin/scripts/