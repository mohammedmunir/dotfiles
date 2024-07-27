#!/bin/bash

# Set Resolve Script

# Get Pi-hole's IP address
PIHOLE_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' pihole)

# Backup current resolv.conf
sudo cp /etc/resolv.conf /etc/resolv.conf.backup

# Set DNS to Pi-hole
echo "nameserver $PIHOLE_IP" | sudo tee /etc/resolv.conf

echo "DNS set to use Pi-hole ($PIHOLE_IP)"
