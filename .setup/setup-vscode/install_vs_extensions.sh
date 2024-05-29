#!/bin/bash

# Check if VSCode is installed
if ! command -v code &> /dev/null; then
  echo "VSCode is not installed. Installing..."
  sudo pacman -S visual-studio-code-bin
fi

# Check if extensions.txt exists and is not empty
if [ ! -f extensions.txt ] || [ ! -s extensions.txt ]; then
  echo "Error: extensions.txt is missing or empty. Please create a file with the list of extensions."
  exit 1
fi

# Read extensions from file
extensions=$(cat extensions.txt)

# Install each extension
for extension in $extensions; do
  code --install-extension $extension
done

echo "All extensions installed!"
