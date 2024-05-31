
#!/bin/bash

# Ensure necessary services are running
echo "Starting Anbox service..."
sudo systemctl start anbox-container-manager.service
sudo systemctl enable anbox-container-manager.service

# Verify if Anbox service is active
if systemctl is-active --quiet anbox-container-manager.service; then
    echo "Anbox service is running."
else
    echo "Failed to start Anbox service. Please check the logs."
    exit 1
fi

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
    else
        echo "Failed to install APK."
    fi
else
    echo "No APK file provided. Skipping APK installation."
fi
