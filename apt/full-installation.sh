echo "Updating the system..."
sudo apt update -y

echo "Starting full installation..."
while read package; do
    echo ""
    echo "Installing $package"
    sudo apt install "$package" -y

done < "$scriptDir/$PM/packagesList/full"
while read package; do
    echo ""
    echo "Installing $package"
    sudo apt install "$package" -y

done < "$scriptDir/$PM/packagesList/full"