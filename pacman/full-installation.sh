echo "Updating the system..."
sudo pacman -Syu --noconfirm

echo "Starting full installation..."
while read package; do
    echo ""
    echo "Installing $package"
    sudo pacman -S "$package" --noconfirm
done < "$scriptDi/$PM/packagesList/minimal"

while read package; do
    echo ""
    echo "Installing $package"
    sudo pacman -S "$package" --noconfirm
done < "$scriptDir/$PM/packagesList/full"