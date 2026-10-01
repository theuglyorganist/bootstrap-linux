echo "Updating the system..."
sudo dnf makecache --refresh

echo "Starting full installation..."
while read package; do
    echo ""
    echo "Installing $package"
    sudo dnf install -y "$package"
done < "$scriptDir/$PM/packagesList/minimal"
while read package; do
    echo ""
    echo "Installing $package"
    sudo dnf install "$package" -y
done < "$scriptDir/$PM/packagesList/full"

#installing flatpak here due missing repo
flatpak install -y com.visualstudio.code
