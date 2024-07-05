#!/bin/bash

# Install ROCm HIP SDK, ROCm OpenCL SDK, and Python 3.10 without requiring user confirmation
sudo pacman -S rocm-hip-sdk rocm-opencl-sdk python310 --noconfirm

# Add the current user to the 'video' group to allow access to the GPU
sudo usermod -a -G video $LOGNAME

# Display ROCm information to check GPU architecture (e.g., gfx version)
rocminfo | grep gfx

# Append the environment variable setting to the .bashrc file
echo "export HSA_OVERRIDE_GFX_VERSION=10.3.0" >> ~/.bashrc

# Source the .bashrc file to apply changes immediately
source ~/.bashrc

# Set up a Python virtual environment using Python 3.10
python3.10 -m venv .venv

# Activate the Python virtual environment
source .venv/bin/activate

# Create a directory for PyTorch and navigate into it
mkdir pytorch && cd pytorch/

# Install PyTorch, torchvision, and torchaudio for ROCm
pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm6.0

# Clone the Stable Diffusion Web UI repository from GitHub
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git
