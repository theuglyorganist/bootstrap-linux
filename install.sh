#!/usr/bin/bash
export scriptDir="$(dirname "$(realpath "$0")")"
source "$scriptDir"/functions.sh
echo ""

#Granting super user powers
sudo -v
if [ $? -eq 0 ]; then
    echo "Sudo authentication: OK"
else
    echo "Sudo authentication failed, aborting..."
    exit 1
fi

export fullSetup=$(validation "Wanna do a full setup? Everything will be downloaded, installed and configured, and there won't be any more questions after this. [Y/n]: ")

#Checking for package manager
packagemanager=("pacman" "apt" "dnf")
for i in ${packagemanager[@]}; do
    command -v "$i" &> /dev/null
    if [ $? -eq 0 ]; then
        PM="$i"
        export PM
        echo "Package manager found: OK"
        break
    fi
done
if [ -z "$PM" ]; then
    echo "Package manager not found, aborting..."
    echo ""
    exit 1
fi

#Checking for internet connection
ping -c 1 1.1.1.1 &> /dev/null
if [ $? -eq 0 ]; then
    echo "Internet connection: OK"
else
    echo "Internet connection not found, aborting..."
    exit 1
fi

echo ""
echo "Starting Bootstrap Install Script..."
echo ""

#Which packages will be installed
if [[ "$fullSetup" == "n" ]]; then
    minimalPInstall=$(validation "Wanna do a minimal package installation? If no, it will install every single package in the packages list. [Y/n] ")
fi

#Installing packages
if [[ "$minimalPInstall" == "y" && "$fullSetup" == "n" ]]; then
    bash "$scriptDir"/"$PM"/minimal-installation.sh
else 
    bash "$scriptDir"/"$PM"/full-installation.sh

    #Installing discord
    echo "Downloading and installing discord..."
    sudo mkdir -p /opt
    sudo wget -O /opt/discord.tar.gz "https://discord.com/api/download/stable?platform=linux&format=tar.gz"
    sudo tar -xf /opt/discord.tar.gz -C /opt
    sudo rm /opt/discord.tar.gz
    sudo mkdir -p /usr/share/applications/
    sudo sed  -i 's|Exec=/usr/bin/discord --url -- %u|Exec=/opt/Discord/discord --url -- %u|' /opt/Discord/discord.desktop
    sudo sed  -i 's|Icon=discord|Icon=/opt/Discord/discord.png|' /opt/Discord/discord.desktop
    sudo cp /opt/Discord/discord.desktop /usr/share/applications/

    echo ""
    echo "Installing flatpaks."
    while read flatpak; do
        flatpak install -y "$flatpak"
    done < "$scriptDir"/flatpaks-packages
fi

#Post installation check
if [[ "$fullSetup" == "n" ]]; then
    postInstallation=$(validation "Wanna do a post installation? [Y/n] ")
fi
if [[ "$fullSetup" == "y" || "$postInstallation" == "y" ]]; then
    bash "$scriptDir"/post-installation.sh
fi

#Wallpapers repo clone
if [[ -d "$HOME/Pictures" ]]; then
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

