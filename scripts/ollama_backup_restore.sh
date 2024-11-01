#!/bin/bash

# Ollama model directory and external drive mount point
OLLAMA_DIR="/usr/share/ollama/.ollama/models"
BACKUP_DIR="/mnt/element/"

# Function to back up files
backup_ollama() {
    echo "Backing up Ollama model files to $BACKUP_DIR..."
    mkdir -p "$BACKUP_DIR"
    # -a for archive mode, -v for verbose, -h for human-readable, --progress for progress bar
    # Rsync automatically skips files that are unchanged
    sudo rsync -avh --progress "$OLLAMA_DIR/" "$BACKUP_DIR"
    echo "Backup completed!"
}

# Function to restore files
restore_ollama() {
    echo "Restoring Ollama model files from $BACKUP_DIR..."
    if [ ! -d "$BACKUP_DIR" ]; then
        echo "Backup directory not found. Please check the backup location."
        exit 1
    fi
    sudo rsync -avh --progress "$BACKUP_DIR/" "$OLLAMA_DIR"
    echo "Restore completed!"
}

# Main script logic
if [ "$1" == "backup" ]; then
    backup_ollama
elif [ "$1" == "restore" ]; then
    restore_ollama
else
    echo "Usage: $0 {backup|restore}"
    exit 1
fi

