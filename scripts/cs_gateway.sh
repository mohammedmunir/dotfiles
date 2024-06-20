#sudo ip addr add 10.0.1.200/24 dev enp1s0


#!/bin/bash

# Define the default interface name in case no network is detected.
default_interface="enp1s0"

# Find the name of the first Ethernet interface (assuming there is one)
interface_name=$(ip -4 addr show | grep 'state UP/UP' | head -n 1 | awk '{print $2}' | sed 's/[0-9]*//' | cut -d':' -f1)

echo "Detected Interface: $interface_name"

# If no interface was found, use the default one.
if [[ ! "$interface_name" ]]; then
    echo "No active Ethernet interfaces found. Proceeding with default interface '$default_interface'."
    interface_name="$default_interface"
fi

# Add the IP address to the found or default interface
sudo ip addr add 10.0.1.200/24 dev "$interface_name"

