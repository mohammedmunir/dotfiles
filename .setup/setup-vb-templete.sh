#!/bin/bash

echo
tput setaf 2
echo "################################################################"
echo "####### Copy paste virtual box template"
echo "################################################################"
tput sgr0
echo	

[ -d $HOME"/VirtualBox VMs" ] || mkdir -p $HOME"/VirtualBox VMs"
sudo cp -rf virtualbox-template/* ~/VirtualBox\ VMs/
cd ~/VirtualBox\ VMs/
tar -xzf template.tar.gz
rm -f template.tar.gz	

