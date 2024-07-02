
#!/bin/bash

# Function to display messages
function print_message() {
    echo -e "\n====== $1 ======\n"
}

# Update system
print_message "Updating system"
sudo pacman -Syu --noconfirm

# Install Docker
print_message "Installing Docker"
sudo pacman -S docker --noconfirm

# Start and enable Docker
print_message "Starting and enabling Docker"
sudo systemctl start docker
sudo systemctl enable docker

# Install AMD GPU drivers
print_message "Installing AMD GPU drivers"
sudo pacman -S xf86-video-amdgpu --noconfirm

# Install ROCm using Yay
print_message "Installing ROCm stack using Yay"
yay -S rocm-dkms --noconfirm

# Pull Fooocus Docker image
FOOOCUS_IMAGE="ashleykza/fooocus:latest"
print_message "Pulling Fooocus Docker image"
sudo docker pull $FOOOCUS_IMAGE

# Remove NVIDIA runtime configuration if it exists
print_message "Removing NVIDIA runtime configuration if it exists"
sudo rm -f /etc/docker/daemon.json

# Restart Docker
print_message "Restarting Docker"
sudo systemctl restart docker

# Run Fooocus with ROCm support
print_message "Running Fooocus with ROCm support"
sudo docker run -d \
  --device=/dev/kfd \
  --device=/dev/dri \
  --group-add video \
  -v /workspace:/workspace \
  -p 3005:3009 \
  -p 8888:8888 \
  -p 2999:2999 \
  -e VENV_PATH="/workspace/venvs/fooocus" \
  $FOOOCUS_IMAGE

print_message "Setup complete!"
