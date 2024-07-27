#!/bin/bash

# Reset Resolve Script

# Check if backup exists
if [ -f /etc/resolv.conf.backup ]; then
    # Restore from backup
    sudo mv /etc/resolv.conf.backup /etc/resolv.conf
    echo "DNS settings restored to original configuration"
else
    # If no backup, set to a common DNS server (e.g., Cloudflare)
    echo "nameserver 1.1.1.1" | sudo tee /etc/resolv.conf
    echo "DNS reset to default (1.1.1.1)"
fi
