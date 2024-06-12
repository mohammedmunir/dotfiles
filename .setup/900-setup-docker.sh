
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

echo "installing portainer..."
docker run -d -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce

echo "Docker installation complete. Please log out and log back in to apply Docker group changes."
