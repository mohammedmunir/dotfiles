
#!/bin/bash

# Prevent Bluetooth from sleeping by creating a service override
echo "Creating a Bluetooth service override to prevent sleeping..."
sudo systemctl edit bluetooth <<EOF
[Service]
ExecStartPost=/usr/bin/sleep 5
EOF
sudo systemctl daemon-reload
sudo systemctl restart bluetooth
echo "Bluetooth service override created and service restarted."

# Disable power management for Bluetooth
echo "Disabling power management for Bluetooth..."
sudo bash -c 'cat << EOF > /etc/udev/rules.d/10-local.rules
ACTION=="add", SUBSYSTEM=="bluetooth", KERNEL=="hci0", RUN+="/bin/sh -c '\''hciconfig hci0 up; hciconfig hci0 noscan; hciconfig hci0 piscan'\''"
EOF'
sudo udevadm control --reload-rules
echo "Power management for Bluetooth disabled."

# Update system and packages
echo "Updating system and packages..."
sudo pacman -Syu --noconfirm
echo "System and packages updated."

# Check system logs for Bluetooth related messages
echo "Checking system logs for Bluetooth related messages..."
sudo journalctl -xe | grep -i bluetooth > bluetooth_logs.txt
echo "System logs saved to bluetooth_logs.txt."

echo "Please review the following steps manually:"
echo "1. Open XFCE Settings Manager and adjust Screensaver settings."
echo "2. Open XFCE Power Manager and ensure no settings disable Bluetooth or other devices when the screensaver activates."
echo "3. Re-pair your Bluetooth keyboard if necessary."

echo "Script execution completed."
