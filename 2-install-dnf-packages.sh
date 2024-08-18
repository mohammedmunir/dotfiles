#!/bin/bash
#
##################################################################################################################
# This script installs various applications, updates system packages, and builds and installs Chadwm
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
    dconf-editor
    flameshot
    gimp
    inkscape
    meld
    qbittorrent
    rxvt-unicode
    vlc
    code        # Visual Studio Code
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
    nitrogen
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
)

for dep in "${build_dependencies[@]}"; do
    if ! is_installed "$dep"; then
        echo "Installing build dependency $dep..."
        sudo dnf install -y "$dep"
    else
        echo "$dep is already installed."
    fi
done

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

# Build and install Chadwm
cp -r arco-chadwm $HOME/.config/
cd $HOME/.config/arco-chadwm/chadwm
make
sudo make install

# Create and configure X session file for Chadwm
if [ ! -f /usr/share/xsessions/chadwm.desktop ]; then
    echo "Creating X session file for Chadwm..."
    sudo tee /usr/share/xsessions/chadwm.desktop > /dev/null <<EOL
[Desktop Entry]
Encoding=UTF-8
Name=Chadwm
Comment=Dynamic window manager
Exec=$HOME/.config/arco-chadwm/scripts/./run.sh
Icon=chadwm
Type=Application
EOL
fi

# Start and enable libvirtd service
sudo systemctl start libvirtd
sudo systemctl enable libvirtd

echo "################################################################"
echo "#################    Chadwm installed     ######################"
echo "################################################################"

