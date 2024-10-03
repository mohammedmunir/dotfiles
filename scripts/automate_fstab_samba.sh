
#!/bin/bash

# Variables
UUID="6338d6d7-8b54-46f8-af0b-e0f5d24fdf73"
MOUNT_POINT="/mnt/element"
SMB_SHARE_NAME="Elements"
USER="abu"
FSTAB_ENTRY="UUID=$UUID  $MOUNT_POINT  ext4  defaults  0  0"
SMB_CONF="/etc/samba/smb.conf"

# Function to update fstab
update_fstab() {
    echo "Adding entry to /etc/fstab..."
    if ! grep -q "$UUID" /etc/fstab; then
        echo "$FSTAB_ENTRY" | sudo tee -a /etc/fstab > /dev/null
        echo "Entry added to /etc/fstab."
    else
        echo "Drive is already listed in /etc/fstab."
    fi
}

# Create mount point if it doesn't exist
create_mount_point() {
    if [ ! -d "$MOUNT_POINT" ]; then
        echo "Creating mount point at $MOUNT_POINT..."
        sudo mkdir -p $MOUNT_POINT
    else
        echo "Mount point $MOUNT_POINT already exists."
    fi
}

# Reload systemd and mount the drive
mount_drive() {
    echo "Reloading systemd and mounting the drive..."
    sudo systemctl daemon-reload
    sudo mount -a
    if mountpoint -q $MOUNT_POINT; then
        echo "Drive mounted successfully."
    else
        echo "Failed to mount the drive."
        exit 1
    fi
}

# Function to update Samba configuration
update_smb_conf() {
    echo "Adding Samba share to smb.conf..."
    if ! grep -q "path = $MOUNT_POINT" $SMB_CONF; then
        echo "
[$SMB_SHARE_NAME]
path = $MOUNT_POINT
available = yes
valid users = $USER
read only = no
browsable = yes
public = yes
writable = yes
" | sudo tee -a $SMB_CONF > /dev/null
        echo "Samba share added."
    else
        echo "Samba share for $MOUNT_POINT already exists."
    fi
}

# Restart Samba services
restart_samba() {
    echo "Restarting Samba services..."
    sudo systemctl restart smb.service
    sudo systemctl restart nmb.service
    echo "Samba services restarted."
}

# Set folder ownership and permissions
set_permissions() {
    echo "Setting permissions for $MOUNT_POINT..."
    sudo chown -R $USER:$USER $MOUNT_POINT
    sudo chmod -R 755 $MOUNT_POINT
    echo "Permissions set."
}

# Main script
echo "Starting automation for /etc/fstab and Samba configuration..."

update_fstab
create_mount_point
mount_drive
set_permissions
update_smb_conf
restart_samba

echo "Automation completed."
