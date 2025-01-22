#!/bin/bash

# Variables
VENV_DIR="$HOME/tts-env"
PYTHON_VERSION="python3.11"
MODEL_NAME="tts_models/en/ljspeech/tacotron2-DDC"
WRAPPER_SCRIPT="$HOME/tts_speak.sh"
SERVER_SCRIPT="$HOME/start_tts_server.sh"
SERVER_PORT=5000  # Avoid using 8000/8080

# Install dependencies
echo "Installing dependencies..."
sudo dnf install -y $PYTHON_VERSION $PYTHON_VERSION-virtualenv python3-devel git cmake gcc gcc-c++ make libsndfile || {
    echo "Failed to install dependencies. Exiting..."
    exit 1
}

# Set up virtual environment
echo "Creating virtual environment with $PYTHON_VERSION..."
$PYTHON_VERSION -m venv "$VENV_DIR" || {
    echo "Failed to create virtual environment. Exiting..."
    exit 1
}

# Activate virtual environment
source "$VENV_DIR/bin/activate"

# Install Coqui TTS
echo "Installing Coqui TTS..."
pip install --upgrade pip || {
    echo "Failed to upgrade pip. Exiting..."
    deactivate
    exit 1
}
pip install TTS || {
    echo "Failed to install TTS. Exiting..."
    deactivate
    exit 1
}

# Verify installation
echo "Verifying Coqui TTS installation..."
tts --list_models > /dev/null || {
    echo "TTS installation failed. Exiting..."
    deactivate
    exit 1
}

# Create a wrapper script for TTS
echo "Creating wrapper script at $WRAPPER_SCRIPT..."
cat << EOF > "$WRAPPER_SCRIPT"
#!/bin/bash
source "$VENV_DIR/bin/activate"
tts --text "\$1" --model_name "$MODEL_NAME" --out_path output.wav
echo "Audio generated: output.wav"
EOF
chmod +x "$WRAPPER_SCRIPT"

# Create a server script for TTS
echo "Creating server script at $SERVER_SCRIPT..."
cat << EOF > "$SERVER_SCRIPT"
#!/bin/bash
source "$VENV_DIR/bin/activate"
tts_server --model_name "$MODEL_NAME" --port $SERVER_PORT
EOF
chmod +x "$SERVER_SCRIPT"

# Test TTS system
echo "Testing TTS with sample text..."
"$WRAPPER_SCRIPT" "This is a test of Coqui TTS with a female voice." || {
    echo "TTS test failed. Check the installation."
    deactivate
    exit 1
}

# Deactivate virtual environment
deactivate

echo "Setup completed successfully!"
echo "Use the wrapper script: $WRAPPER_SCRIPT <text>"
echo "Start the server using: $SERVER_SCRIPT (port: $SERVER_PORT)"

