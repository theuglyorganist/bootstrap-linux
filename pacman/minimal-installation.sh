echo "Updating the system..."
sudo pacman -Syu --noconfirm

echo "Starting minimal installation..."
while read package; do
    echo ""
    echo "Installing $package"
    sudo pacman -S "$package" --noconfirm
done < "$scriptDir/$PM/packagesList/minimal"
