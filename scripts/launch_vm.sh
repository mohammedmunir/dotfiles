#!/bin/bash
#  _                           _      __     ____  __  
# | |    __ _ _   _ _ __   ___| |__   \ \   / /  \/  | 
# | |   / _` | | | | '_ \ / __| '_ \   \ \ / /| |\/| | 
# | |__| (_| | |_| | | | | (__| | | |   \ V / | |  | | 
# |_____\__,_|\__,_|_| |_|\___|_| |_|    \_/  |_|  |_| 
#                                                      
# ----------------------------------------------------- 

vm_name="win11-base"
win11user="abu"
win11pass="munir52"

# Check the status of the VM
vm_status=$(virsh --connect qemu:///system domstate $vm_name)

if [ "$vm_status" != "running" ]; then
    virsh --connect qemu:///system start $vm_name
    echo "Virtual Machine $vm_name is starting... Waiting 200 seconds for booting up."
    notify-send "Virtual Machine $vm_name is starting..." "Waiting 200 seconds for booting up."
    sleep 200
else
    notify-send "Virtual Machine $vm_name is already running." "Launching xfreerdp now!"
    echo "Starting xfreerdp now..."
fi

# Wait for the VM to be fully up and running
sleep 30

# Find the IP address of the VM
mac_address=$(virsh --connect qemu:///system domiflist $vm_name | grep -oP '([0-9a-f]{2}:){5}[0-9a-f]{2}')
ip_address=$(arp -an | grep "$mac_address" | awk '{print $2}' | tr -d '()')

if [ -z "$ip_address" ]; then
    echo "Failed to obtain IP address for $vm_name."
    notify-send "Failed to obtain IP address for $vm_name."
    exit 1
fi

# Launch xfreerdp with the obtained IP address
xfreerdp /grab-keyboard /v:$ip_address /size:100% /cert:ignore /u:$win11user /p:$win11pass /d: /dynamic-resolution &
