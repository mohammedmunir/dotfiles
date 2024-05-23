
#!/bin/bash

set -e

# Install Docker and Docker Compose
echo "Installing Docker and Docker Compose..."
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm docker docker-compose

# Start and enable Docker service
echo "Starting and enabling Docker service..."
sudo systemctl start docker
sudo systemctl enable docker

# Add current user to the docker group
sudo usermod -aG docker $USER

echo "Docker installation complete. Please log out and log back in to apply Docker group changes."
