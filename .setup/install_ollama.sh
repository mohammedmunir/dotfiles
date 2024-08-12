#!/bin/bash

# Check if ollama is installed
if ! command -v ollama &> /dev/null; then
    echo "Ollama is not installed. Installing Ollama..."
    # Install ollama
    sudo pacman -S --noconfirm --needed ollama
fi

# Check if Ollama is running
if ! pgrep -x "ollama" >/dev/null; then
    echo "Ollama is not running. Starting Ollama..."
    # Start Ollama
    ollama serve &
    # Wait for Ollama to start
    sleep 5
    echo "Ollama started."
fi

# Pull desired models from the registry
ollama pull qwen2
ollama pull qwen2:1.5b
#ollama run stable-code
#ollama run mistral-nemo

echo "Model pull completed."

echo "lets install proplexity"
echo "installing nomic-embed-text"
ollama pull nomic-embed-text

#https://github.com/ItzCrazyKns/Perplexica


cd /home/abu/Documents/repo/
git clone https://github.com/ItzCrazyKns/Perplexica.git

echo "Perplexica cloned successfully."
cd Perplexica