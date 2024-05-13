#!/bin/bash
# ------------------------------------------------------
# setup Git user details
# ------------------------------------------------------
sudo pacman -S --noconfirm --needed git

git config --global user.name "mohammedmunir"
git config --global user.email "mohammed.munir@gmail.com"

# ------------------------------------------------------
# setup SSH Multi
# ------------------------------------------------------
ssh-keygen -t rsa -C "mohammed.munir@gmail.com"
ssh-keygen -t rsa -f ~/.ssh/arch -C "mohammed.munir@gmail.com"

#touch ~/.ssh/config

# ------------------------------------------------------
# Setup Multi SSH file
# ------------------------------------------------------
echo "Host github.com-arch" > ~/.ssh/config
echo -e "\tHostname github.com" >> ~/.ssh/config
echo -e "\tidentityFile=~/.ssh/arch" >> ~/.ssh/config
