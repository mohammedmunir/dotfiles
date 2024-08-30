#!/bin/bash
#
##################################################################################################################
# This script installs various applications, updates system packages, installs pip packages, installs fonts, and builds and installs Chadwm
##################################################################################################################

# Function to check if a package is installed
is_installed() {
    local package=$1
    dnf list installed "$package" &> /dev/null
}

# Update system and install RPM Fusion repositories
sudo dnf update -y
if ! is_installed "rpmfusion-free-release"; then
    sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
fi
if ! is_installed "rpmfusion-nonfree-release"; then
    sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
fi

# List of core and additional packages to install
packages=(
    neovim
    gnome-tweaks
    git
    qemu
    qemu-kvm
    libvirt
    libvirt-daemon
    libvirt-daemon-config-network
    virt-manager
    polkit-gnome
    dconf-editor
    flameshot
    gimp
    inkscape
    meld
    qbittorrent
    rxvt-unicode
    vlc
    code  # Visual Studio Code
    thorium-browser_126.0.6478.231_AVX.rpm
    acpi
    arandr
    autorandr
    catfish
    duf
    feh
    font-manager
    hw-probe
    lolcat
    lxappearance
    most
    nomacs
    numlockx
    pavucontrol
    picom
    ripgrep
    rofi
    suckless-tools
    sxhkd
    thunar
    thunar-archive-plugin
    variety
    xfce4-taskmanager
    xfce4-terminal
    the_silver_searcher  # Equivalent to `silversearcher-ag`
    samba
    alacritty
    golang
    python3-pip
    python3-venv
    zoxide
    fastfetch
    ffmpeg
    fira-code-fonts
    noto-fonts
    dejavu-fonts
    powerline-fonts
    xautolock
    slock
    arp-scan
)

# Install packages if not already installed
for pkg in "${packages[@]}"; do
    if ! is_installed "$pkg"; then
        echo "Installing $pkg..."
        sudo dnf install -y "$pkg"
    else
        echo "$pkg is already installed."
    fi
done

# Install build dependencies for Chadwm
build_dependencies=(
    gcc
    gcc-c++
    make
    imlib2-devel
    libX11-devel
    libXft-devel
    libXinerama-devel
    freetype-devel
    fontconfig-devel
    libssl-devel
    libffi-devel
    python3-devel
)

for dep in "${build_dependencies[@]}"; do
    if ! is_installed "$dep"; then
        echo "Installing build dependency $dep..."
        sudo dnf install -y "$dep"
    else
        echo "$dep is already installed."
    fi
done

# Install development tools group
if ! sudo dnf group list installed "Development Tools" &> /dev/null; then
    echo "Installing Development Tools group..."
    sudo dnf groupinstall -y "Development Tools"
else
    echo "Development Tools group is already installed."
fi

# Install pip packages
pip_packages=(
    torch
    onnxruntime
    yaml
    pyyaml
    gradio
    opencv-python
    scipy
    insightface
    psutil
)

for pip_pkg in "${pip_packages[@]}"; do
    if ! pip show "$pip_pkg" &> /dev/null; then
        echo "Installing pip package $pip_pkg..."
        pip install "$pip_pkg"
    else
        echo "Pip package $pip_pkg is already installed."
    fi
done

# Install fonts from dotfiles/fonts
font_dir="$HOME/.local/share/fonts"
mkdir -p "$font_dir"

echo "Installing custom fonts..."
for zip_file in /home/abu/dotfiles/fonts/*.zip; do
    echo "Unzipping $zip_file..."
    unzip -o "$zip_file" -d "$font_dir"
done

# Refresh the font cache
echo "Refreshing font cache..."
fc-cache -fv

# Configure Samba
if [ ! -f /etc/samba/smb.conf.bak ]; then
    echo "Backing up existing Samba configuration..."
    sudo mv /etc/samba/smb.conf /etc/samba/smb.conf.bak
fi
if [ ! -f /etc/samba/smb.conf ]; then
    echo "Downloading new Samba configuration..."
    sudo wget https://raw.githubusercontent.com/arcolinux/arcolinux-system-config/master/etc/samba/smb.conf.arcolinux -O /etc/samba/smb.conf
fi
echo "Remove the semi-colons from the last lines of the Samba configuration file if required."

# Create shared directory
mkdir -p $HOME/SHARED

# Start and enable libvirtd service
sudo systemctl start libvirtd
sudo systemctl enable libvirtd

sudo systemctl enable --now polkit.service

sudo usermod -aG libvirt $(whoami)



