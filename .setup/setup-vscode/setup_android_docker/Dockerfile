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
