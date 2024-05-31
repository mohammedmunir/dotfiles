
#!/bin/bash

# Update the system
echo "Updating the system..."
sudo pacman -Syu --noconfirm

# Install Anbox and necessary kernel modules
echo "Installing Anbox and kernel modules..."
yay -S anbox-git anbox-modules-dkms-git --noconfirm

# Load kernel modules
echo "Loading kernel modules..."
sudo modprobe ashmem_linux
sudo modprobe binder_linux

# Enable kernel modules at boot
echo "Enabling kernel modules at boot..."
echo 'ashmem_linux' | sudo tee /etc/modules-load.d/anbox.conf
echo 'binder_linux' | sudo tee -a /etc/modules-load.d/anbox.conf

# Start and enable Anbox service
echo "Starting and enabling Anbox service..."
sudo systemctl start anbox-container-manager.service
sudo systemctl enable anbox-container-manager.service

# Verify installation
echo "Verifying installation..."
if systemctl is-active --quiet anbox-container-manager.service; then
    echo "Anbox installation and setup completed successfully!"
else
    echo "There was an issue starting the Anbox service. Please check the logs."
fi

echo "To install APK files, use the following command:"
echo "adb install /path/to/your/app.apk"
