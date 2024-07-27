#!/bin/bash

set -e

# Define the storage directory
STORAGE_DIR=~/Documents/android_storage

# Install required packages
# sudo pacman -Syu --noconfirm
# sudo pacman -S --noconfirm wget unzip pulseaudio adb qemu libvirt virt-manager ebtables dnsmasq bridge-utils openjdk-8-jdk

# Create the storage directory
mkdir -p $STORAGE_DIR

# Create a Dockerfile for the Android environment
cat << 'EOF' > Dockerfile
# Use an Ubuntu base image
FROM ubuntu:20.04

# Install required packages
RUN apt-get update && apt-get install -y \
    openjdk-8-jdk \
    wget \
    unzip \
    pulseaudio \
    adb \
    fuse \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV ANDROID_HOME /opt/android-sdk
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

# Download and install Android SDK
RUN mkdir -p ${ANDROID_HOME} && \
    cd ${ANDROID_HOME} && \
    wget https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip -O sdk-tools.zip && \
    unzip sdk-tools.zip && \
    rm sdk-tools.zip

# Accept Android SDK licenses
RUN mkdir -p ~/.android && \
    echo "### User Sources for Android SDK Manager" > ~/.android/repositories.cfg && \
    yes | ${ANDROID_HOME}/tools/bin/sdkmanager --licenses

# Install Android 16 (Jelly Bean) platform tools
RUN ${ANDROID_HOME}/tools/bin/sdkmanager "platforms;android-16"

# Install QEMU for Android Emulator
RUN ${ANDROID_HOME}/tools/bin/sdkmanager "emulator"

# Install necessary packages for USB support
RUN apt-get update && apt-get install -y \
    libpulse0 \
    libsdl2-2.0-0 \
    libsdl2-dev \
    libqt5widgets5 \
    libqt5gui5 \
    libqt5core5a \
    && rm -rf /var/lib/apt/lists/*

# Expose necessary ports
EXPOSE 5554 5555 5900

# Start the Android emulator
CMD ${ANDROID_HOME}/emulator/emulator -avd test -no-audio -no-window -gpu swiftshader_indirect -qemu -usb -usbdevice tablet
EOF

# Build the Docker image
sudo docker build -t android-16 .

# Run a container to create an Android Virtual Device (AVD)
sudo docker run -it --rm --device /dev/kvm android-16 bash -c "
echo 'no' | ${ANDROID_HOME}/tools/bin/avdmanager create avd -n test -k 'system-images;android-16;default;x86'
"

# Run the Docker container with sound and USB support, using the defined storage directory
sudo docker run -it --rm \
    --device /dev/kvm \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e DISPLAY=$DISPLAY \
    --privileged \
    -v /dev/bus/usb:/dev/bus/usb \
    -v $STORAGE_DIR:/root/storage \
    android-16
