#!/bin/bash

# Pi-hole Update Script

echo "Updating Pi-hole..."

# Pull the latest Pi-hole image
docker pull pihole/pihole:latest

# Stop and remove the current container
docker stop pihole
docker rm pihole

# Run the updated container
docker run -d \
    --name pihole \
    -p 53:53/tcp -p 53:53/udp \
    -p 80:80 \
    -e TZ="Your/Timezone" \
    -v "${HOME}/pihole/etc-pihole:/etc/pihole" \
    -v "${HOME}/pihole/etc-dnsmasq.d:/etc/dnsmasq.d" \
    --dns=127.0.0.1 --dns=1.1.1.1 \
    --restart=unless-stopped \
    --network pihole-network \
    pihole/pihole:latest

echo "Pi-hole updated successfully!"
