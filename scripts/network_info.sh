
#!/bin/sh

# Set specific network interface names
WIRED_INTERFACE="enp0s31f6"
WIFI_INTERFACE="wlan0"

# Fetch wired IP
WIRED_IP=$(ip -4 addr show dev "$WIRED_INTERFACE" | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
if [ -z "$WIRED_IP" ]; then
    WIRED_IP="Not connected"
fi

# Fetch wireless IP
WIFI_IP=$(ip -4 addr show dev "$WIFI_INTERFACE" | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
if [ -z "$WIFI_IP" ]; then
    WIFI_IP="Not connected"
fi

# Fetch WiFi speed
WIFI_SPEED=$(iwconfig "$WIFI_INTERFACE" 2>/dev/null | grep 'Bit Rate' | awk '{print $2 $3}')
if [ -z "$WIFI_SPEED" ]; then
    WIFI_SPEED="N/A"
fi

echo "Wired IP: $WIRED_IP"
echo "WiFi IP: $WIFI_IP"
echo "WiFi Speed: $WIFI_SPEED"
