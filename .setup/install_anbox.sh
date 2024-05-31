
#!/bin/bash

# Ensure necessary services are running
echo "Starting Anbox service..."
sudo systemctl start anbox-container-manager.service

# Check if the Anbox service exists, create it if not
if ! systemctl list-unit-files | grep -q anbox-container-manager.service; then
    echo "Anbox service file not found. Creating the service file..."
    sudo bash -c 'cat <<EOF > /etc/systemd/system/anbox-container-manager.service
[Unit]
Description=Anbox Container Manager
Documentation=man:anbox(1)
After=network.target

[Service]
ExecStart=/usr/bin/anbox container-manager --daemon --privileged
Restart=on-failure
User=root
Group=root
PermissionsStartOnly=true
ExecStartPre=/sbin/modprobe ashmem_linux
ExecStartPre=/sbin/modprobe binder_linux

[Install]
WantedBy=multi-user.target
EOF'
    sudo systemctl daemon-reload
    sudo systemctl enable anbox-container-manager.service
    sudo systemctl start anbox-container-manager.service
fi

# Verify if Anbox service is active
if systemctl is-active --quiet anbox-container-manager.service; then
    echo "Anbox service is running."
else
    echo "Failed to start Anbox service. Please check the logs."
    exit 1
fi

# Load kernel modules
echo "Loading kernel modules..."
sudo modprobe ashmem_linux
sudo modprobe binder_linux

# Enable kernel modules at boot
echo "Enabling kernel modules at boot..."
echo 'ashmem_linux' | sudo tee /etc/modules-load.d/anbox.conf
echo 'binder_linux' | sudo tee -a /etc/modules-load.d/anbox.conf

# Launch Anbox Application Manager
echo "Launching Anbox Application Manager..."
anbox.appmgr &

# Wait for Anbox to start
sleep 5

# Install APK if provided as an argument
if [ -n "$1" ]; then
    echo "Installing APK: $1"
    adb install "$1"
    if [ $? -eq 0 ]; then
        echo "APK installed successfully."
        echo "Opening Anbox Application Manager. Please find and launch your installed app there."
    else
        echo "Failed to install APK."
    fi
else
    echo "No APK file provided. Skipping APK installation."
fi

# Ensure proper shutdown of Anbox
echo "To ensure data persistence, please exit applications properly and then stop the Anbox service using:"
echo "sudo systemctl stop anbox-container-manager.service"
