#!/bin/bash

set -e

# Install Docker Buildx plugin
echo "Installing Docker Buildx plugin..."
mkdir -p ~/.docker/cli-plugins
DOCKER_BUILDX_VERSION=$(curl -s https://api.github.com/repos/docker/buildx/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
curl -Lo ~/.docker/cli-plugins/docker-buildx "https://github.com/docker/buildx/releases/download/${DOCKER_BUILDX_VERSION}/buildx-${DOCKER_BUILDX_VERSION}.linux-amd64"
chmod +x ~/.docker/cli-plugins/docker-buildx

# Enable BuildKit
export DOCKER_BUILDKIT=1

# Create a directory for the Docker setup
mkdir -p ~/flutter-android-docker
cd ~/flutter-android-docker

# Create Dockerfile
cat <<EOF > Dockerfile
# Use the official Flutter image as the base image
FROM cirrusci/flutter:latest

# Install necessary dependencies for Android SDK and emulator
RUN apt-get update && apt-get install -y \
    wget \
    tar \
    unzip \
    lib32stdc++6 \
    lib32z1 \
    libgl1-mesa-dri \
    libgl1-mesa-glx \
    libgles2-mesa \
    openjdk-11-jdk \
    && rm -rf /var/lib/apt/lists/*

# Set up Android SDK environment variables
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV PATH=\${PATH}:\${ANDROID_SDK_ROOT}/tools:\${ANDROID_SDK_ROOT}/tools/bin:\${ANDROID_SDK_ROOT}/platform-tools

# Download and install Android SDK
RUN mkdir -p \${ANDROID_SDK_ROOT} && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-7302050_latest.zip -O /tmp/cmdline-tools.zip && \
    unzip /tmp/cmdline-tools.zip -d \${ANDROID_SDK_ROOT}/cmdline-tools && \
    rm /tmp/cmdline-tools.zip

# Install Android SDK components
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "platforms;android-30" "emulator" "system-images;android-30;google_apis;x86_64"

# Create and start an Android emulator
RUN echo "no" | avdmanager create avd -n test -k "system-images;android-30;google_apis;x86_64"
CMD emulator -avd test -no-window -no-audio -no-boot-anim -gpu swiftshader_indirect -no-snapshot

# Expose necessary ports
EXPOSE 5554 5555 5900

# Entry point to keep the container running
ENTRYPOINT ["/bin/bash"]
EOF

# Create .devcontainer configuration
mkdir -p .devcontainer
cat <<EOF > .devcontainer/devcontainer.json
{
  "name": "Flutter Android",
  "context": "..",
  "dockerFile": "../Dockerfile",
  "runArgs": ["--privileged"],
  "appPort": [5554, 5555, 5900],
  "extensions": [
    "Dart-Code.flutter",
    "Dart-Code.dart-code",
    "ms-vscode-remote.remote-containers"
  ],
  "remoteUser": "root",
  "postCreateCommand": "flutter doctor"
}
EOF

# Build the Docker image
echo "Building Docker image with BuildKit..."
DOCKER_BUILDKIT=1 docker build -t flutter-android .

# Run the Docker container
echo "Running Docker container..."
docker run --privileged -d -p 5554:5554 -p 5555:5555 -p 5901:5900 --name flutter_android_emulator flutter-android

echo "Docker container is running. You can access it using 'docker exec -it flutter_android_emulator /bin/bash'."
echo "To connect to the Android emulator, use 'adb connect localhost:5555'."
echo "You can now use Visual Studio Code with the Remote - Containers extension to open the ~/flutter-android-docker directory."

