#!/bin/bash

# Update the system package list
echo "Updating system package list..."
sudo pacman -Syu --noconfirm

# Install Python and pip if not already installed
echo "Installing Python and pip..."
sudo pacman -S --noconfirm python python-pip

# Create a directory for the virtual environment if it doesn't exist
VENV_DIR="$HOME/myenv"
if [ ! -d "$VENV_DIR" ]; then
    echo "Creating virtual environment directory..."
    mkdir -p "$VENV_DIR"
fi

# Create the virtual environment
echo "Creating virtual environment..."
python -m venv "$VENV_DIR"

# Inform the user
echo "Setup complete. The virtual environment will be activated automatically when you start a new terminal session."
