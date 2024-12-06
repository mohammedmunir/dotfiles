#!/bin/bash

set -e

# Define constants
ANDROID_STUDIO_URL="https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2024.1.1.1/android-studio-2024.1.1.1-linux.tar.gz"
ANDROID_HOME="$HOME/Android/Sdk"

# Update and install required packages
echo "Updating system and installing required packages..."
sudo dnf update -y
sudo dnf install -y java-17-openjdk java-17-openjdk-devel wget unzip libstdc++.i686 zlib.i686 ncurses-libs.i686 \
    bzip2-libs.i686 python3-pip libXrandr libXinerama libXcursor mesa-libGL-devel mesa-libEGL \
    qemu-kvm libvirt virt-install virt-manager kotlin gradle maven

# Verify Java installation
if ! java -version; then
    echo "Java installation failed. Exiting."
    exit 1
fi

# Install Android Studio
echo "Downloading and installing Android Studio..."
mkdir -p $HOME/Downloads
cd $HOME/Downloads
wget -O android-studio.tar.gz $ANDROID_STUDIO_URL
tar -xzf android-studio.tar.gz -C $HOME

# Add Android Studio to PATH
echo "export PATH=\"$HOME/android-studio/bin:$PATH\"" >> ~/.bashrc
source ~/.bashrc

# Set up Android SDK
echo "Setting up Android SDK..."
mkdir -p "$ANDROID_HOME"
echo "export ANDROID_HOME=\"$ANDROID_HOME\"" >> ~/.bashrc
export ANDROID_HOME="$ANDROID_HOME"
echo "export PATH=\"$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$PATH\"" >> ~/.bashrc
source ~/.bashrc

# Install Command-Line Tools
sdk_tools_url="https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip"
wget -O cmdline-tools.zip $sdk_tools_url
unzip cmdline-tools.zip -d $ANDROID_HOME
mkdir -p "$ANDROID_HOME/cmdline-tools/latest"
mv $ANDROID_HOME/cmdline-tools/cmdline-tools/* $ANDROID_HOME/cmdline-tools/latest
rm -rf $ANDROID_HOME/cmdline-tools/cmdline-tools cmdline-tools.zip

# Install required SDK components
echo "Installing required SDK components..."
yes | sdkmanager --install "platform-tools" "platforms;android-33" "build-tools;33.0.0" "system-images;android-33;google_apis;x86_64"

# Create an Android Virtual Device (AVD)
echo "Creating an Android Virtual Device (AVD)..."
avdmanager create avd -n test_device -k "system-images;android-33;google_apis;x86_64" --device "pixel"

# Verify emulator installation
echo "Verifying emulator installation..."
emulator -list-avds

# Print completion message
echo "Setup completed! To start Android Studio, run: studio.sh"
echo "To launch the emulator, run: emulator @test_device"
