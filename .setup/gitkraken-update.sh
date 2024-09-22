#!/bin/bash

# Enter /opt folder (common folder for user installed programs)
# This script assumes you have proper permissions on /opt
cd /opt

# Download GitKraken
#wget https://release.gitkraken.com/linux/gitkraken-amd64.tar.gz
wget http://release.gitkraken.com/linux/gitkraken-amd64.tar.gz

# Delete Old gitkraken if exists.
if [ -d gitkraken/ ]; then
  rm -rf gitkraken
fi

# Extract the Kraken into /opt directory
tar -xvzf gitkraken-amd64.tar.gz

# Remove tar.gz
rm gitkraken-amd64.tar.gz

# Add gitkraken to PATH
echo "export PATH=\$PATH:/opt/gitkraken" >> ~/.bashrc
source ~/.bashrc

# Download gitkraken launcher icon
wget http://img.informer.com/icons_mac/png/128/422/422255.png
mv 422255.png ./gitkraken/icon.png

sudo ln -s /usr/lib64/libcurl.so.4 /usr/lib64/libcurl-gnutls.so.4

# Create desktop entry
sudo touch /usr/share/applications/gitkraken.desktop

# copy the following contents into gitkraken.desktop file:
echo "
[Desktop Entry]
Name=GitKraken
Comment=Git Flow
Exec=/opt/gitkraken/gitkraken
Icon=/opt/gitkraken/icon.png
Terminal=false
Type=Application
Encoding=UTF-8
Categories=Utility;Development;" | sudo tee -a /usr/share/applications/gitkraken.desktop >/dev/null