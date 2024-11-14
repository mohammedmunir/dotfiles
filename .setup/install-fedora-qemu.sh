#!/bin/bash

# Install necessary packages
sudo dnf install -y libvirt libvirt-daemon libvirt-client qemu-kvm virt-manager virt-viewer dnsmasq bridge-utils edk2-ovmf dmidecode

# Enable and start the libvirtd service
sudo systemctl enable libvirtd
sudo systemctl start libvirtd

# Allow the current user to access libvirt and KVM
user=$(whoami)
sudo usermod -a -G libvirt,kvm $user

# Configure the default libvirt network
sudo virsh net-define /etc/libvirt/qemu/networks/default.xml
sudo virsh net-autostart default
sudo systemctl restart libvirtd

echo "############################################################################################################"
echo "#####################                        FIRST REBOOT                              #####################"
echo "############################################################################################################"
