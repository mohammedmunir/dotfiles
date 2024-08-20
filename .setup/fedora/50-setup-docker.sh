#!/bin/bash
set -e

# Install Docker and Docker Compose
echo "Installing Docker and Docker Compose..."
sudo dnf update -y
sudo dnf install -y dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Start and enable Docker service
echo "Starting and enabling Docker service..."
sudo systemctl start docker
sudo systemctl enable docker

# Add current user to the docker group
sudo usermod -aG docker $USER

echo "Installing portainer..."
docker run -d -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce

echo "Setting up watchtower for docker..."
docker run -d \
--name watchtower \
-v /var/run/docker.sock:/var/run/docker.sock \
containrrr/watchtower

echo "Docker installation complete. Please log out and log back in to apply Docker group changes."
