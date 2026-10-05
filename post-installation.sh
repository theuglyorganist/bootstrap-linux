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

#Moving and creating scripts directory
if [[ -d /usr/bin/scripts ]]; then
    echo "Scripts directory already exist."
else
    if [[ "$fullSetup" == "n" ]]; then
        scriptsDirectory=$(validation "Wanna copy bash scripts directory? [Y/n] ")
    fi
    if [[ "$fullSetup" == "y" || "$scriptsDirectory" == "y" ]]; then
        echo "Moving scripts to path..."
        sudo mkdir -p /usr/bin/scripts
        echo 'export PATH="$PATH:/usr/bin/scripts"' >> "$HOME/.bashrc" 
        sudo cp "$scriptDir"/scripts/* /usr/bin/scripts/
    fi
fi

#Wallpapers repo clone
if [[ -d "$HOME/Pictures/Wallpapers" ]]; then
    echo "Wallpapers directory already exist"
else
    if [[ "$fullSetup" == "n" ]]; then
        wallpapersRepo=$(validation "Wanna clone TheUglyOrganist's wallpapers repository? [Y/n] ")
    fi
    if [[ "$fullSetup" == "y" || "$wallpapersRepo" == "y" ]]; then
        mkdir -p $HOME/Pictures
        echo "Cloning repo..."
        git clone https://github.com/theuglyorganist/Wallpapers $HOME/Pictures/
    fi
fi

