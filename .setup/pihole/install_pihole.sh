
#!/bin/bash

# Check if pihole network exists, if not create it
if ! docker network inspect pihole-network >/dev/null 2>&1; then
    docker network create pihole-network
else
    echo "pihole-network already exists"
fi

# Stop and remove existing pihole container if it exists
if docker ps -a | grep -q pihole; then
    echo "Stopping and removing existing pihole container"
    docker stop pihole
    docker rm pihole
fi

# Create directories for Pi-hole configuration
mkdir -p "${HOME}/pihole/etc-pihole"
mkdir -p "${HOME}/pihole/etc-dnsmasq.d"

# Ensure correct permissions for mounted directories
sudo chown -R $(whoami):$(whoami) "${HOME}/pihole/etc-pihole"
sudo chown -R $(whoami):$(whoami) "${HOME}/pihole/etc-dnsmasq.d"

# Generate a new password for Pi-hole
NEW_PASSWORD=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-16}; echo;)

# Run Pi-hole container with specified ports and settings
docker run -d \
    --name pihole \
    -p 5354:53/tcp -p 5354:53/udp \
    -p 8080:80 \
    -e TZ="Europe/London" \
    -e WEBPASSWORD="${NEW_PASSWORD}" \
    -v "${HOME}/pihole/etc-pihole:/etc/pihole" \
    -v "${HOME}/pihole/etc-dnsmasq.d:/etc/dnsmasq.d" \
    --dns=8.8.8.8 --dns=1.1.1.1 \
    --restart=unless-stopped \
    --network pihole-network \
    --privileged \
    pihole/pihole:latest

# Wait for the container to start
echo "Waiting for Pi-hole to start..."
sleep 10

# Display the password
echo "The password for Pi-hole admin interface is: ${NEW_PASSWORD}"

# Inform user of successful installation and access details
echo "Pi-hole installed successfully!"
echo "Pi-hole DNS is available on port 5354"
echo "Pi-hole admin interface is available on port 8080"
echo "To access the Pi-hole admin interface, go to http://localhost:8080/admin"
