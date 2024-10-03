
#!/bin/bash

# Bluetooth Keepalive Systemd Service
echo "Creating Bluetooth Keepalive service..."
sudo bash -c 'cat > /etc/systemd/system/bluetooth-keepalive.service <<EOL
[Unit]
Description=Bluetooth Keepalive
After=bluetooth.service

[Service]
ExecStart=/usr/bin/bluetoothctl power on
Type=oneshot

[Install]
WantedBy=multi-user.target
EOL'

# Enable and start the Bluetooth keepalive service
echo "Enabling and starting Bluetooth Keepalive service..."
sudo systemctl enable bluetooth-keepalive.service
sudo systemctl start bluetooth-keepalive.service

# Wi-Fi Keepalive Systemd Service
echo "Creating Wi-Fi Keepalive service..."
sudo bash -c 'cat > /etc/systemd/system/wifi-keepalive.service <<EOL
[Unit]
Description=Wi-Fi Keepalive
After=network.target

[Service]
ExecStart=/usr/sbin/nmcli radio wifi on
Type=oneshot

[Install]
WantedBy=multi-user.target
EOL'

# Enable and start the Wi-Fi keepalive service
echo "Enabling and starting Wi-Fi Keepalive service..."
sudo systemctl enable wifi-keepalive.service
sudo systemctl start wifi-keepalive.service

# Update TLP power management settings
echo "Modifying TLP power management settings..."
sudo sed -i 's/^USB_AUTOSUSPEND=.*/USB_AUTOSUSPEND=0/' /etc/default/tlp
sudo sed -i '/^WIFI_PWR_ON_AC=.*/c\WIFI_PWR_ON_AC=off' /etc/default/tlp
sudo sed -i '/^WIFI_PWR_ON_BAT=.*/c\WIFI_PWR_ON_BAT=off' /etc/default/tlp

# Restart TLP service to apply changes
echo "Restarting TLP to apply changes..."
sudo systemctl restart tlp

echo "Setup complete! Bluetooth and Wi-Fi should now stay on."
