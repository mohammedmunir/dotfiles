
#!/bin/bash

# Directory and file paths
CONFIG_DIR="$HOME/.config/waydroid"
CONFIG_FILE="$CONFIG_DIR/waydroid_base.ini"

# Create the directory if it doesn't exist
if [ ! -d "$CONFIG_DIR" ]; then
  echo "Creating configuration directory: $CONFIG_DIR"
  mkdir -p "$CONFIG_DIR"
else
  echo "Configuration directory already exists: $CONFIG_DIR"
fi

# Create the configuration file with the clipboard setting
echo "Creating configuration file: $CONFIG_FILE"
cat <<EOL > "$CONFIG_FILE"
[waydroid]
enable_clipboard = true
EOL

echo "Configuration file created successfully."

# Verify the file contents
echo "Verifying configuration file contents:"
cat "$CONFIG_FILE"
