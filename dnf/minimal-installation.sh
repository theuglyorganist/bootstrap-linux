echo "Updating the system..."
sudo dnf makecache --refresh

echo "Starting minimal installation..."
while read package; do
    echo ""
    echo "Installing $package"
    sudo dnf install -y "$package"
done < "$scriptDir/$PM/packagesList/minimal"