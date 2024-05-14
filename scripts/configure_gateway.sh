#!/bin/bash

# Enable IP forwarding
echo "1" | sudo tee /proc/sys/net/ipv4/ip_forward

# Configure IP addresses
sudo ip addr add 10.0.1.200/24 dev enp0s31f6

# Enable NAT
sudo iptables -t nat -A POSTROUTING -o wlp3s0 -j MASQUERADE

# Configure routing
sudo ip route add default via 10.0.1.1 dev wlp3s0

# Update DNS settings
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
echo "nameserver 8.8.4.4" | sudo tee -a /etc/resolv.conf
