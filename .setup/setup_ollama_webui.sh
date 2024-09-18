
#!/bin/bash

# Function to install Docker on Fedora
install_docker_fedora() {
    sudo dnf -y install dnf-plugins-core
    sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    sudo dnf install -y docker-ce docker-ce-cli containerd.io
    sudo systemctl start docker
    sudo systemctl enable docker
}

# Function to install Docker on Debian-based systems
install_docker_debian() {
    sudo apt update
    sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io
    sudo systemctl start docker
    sudo systemctl enable docker
}

# Function to install Docker on Arch-based systems
install_docker_arch() {
    sudo pacman -Syu --noconfirm
    sudo pacman -S --noconfirm docker
    sudo systemctl start docker
    sudo systemctl enable docker
}

# Detect the OS and call the appropriate function
if [ -f /etc/os-release ]; then
    . /etc/os-release
    case "$ID" in
        fedora)
            echo "Detected Fedora system"
            install_docker_fedora
            ;;
        ubuntu|debian)
            echo "Detected Debian-based system: $ID"
            install_docker_debian
            ;;
        arch)
            echo "Detected Arch-based system: $ID"
            install_docker_arch
            ;;
        *)
            echo "Unsupported Linux distribution: $ID"
            exit 1
            ;;
    esac
else
    echo "Cannot detect the OS. /etc/os-release file not found."
    exit 1
fi

# Pull and run the Open WebUI Docker image
docker run -d -p 3000:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main

echo "Ollama and Open WebUI setup complete. Access it at http://localhost:3000"
