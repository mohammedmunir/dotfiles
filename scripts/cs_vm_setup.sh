#!/bin/bash
#  _                           _      __     ____  __  
# | |    __ _ _   _ _ __   ___| |__   \ \   / /  \/  | 
# | |   / _` | | | | '_ \ / __| '_ \   \ \ / /| |\/| | 
# | |__| (_| | |_| | | | | (__| | | |   \ V / | |  | | 
# |_____\__,_|\__,_|_| |_|\___|_| |_|    \_/  |_|  |_| 
#                                                      
#  
# ----------------------------------------------------- 

notify-send "setting ip for vm"

tmp=$(virsh --connect qemu:///system list | grep $vm_name | awk '{ print $3}')

if ([ "x$tmp" == "x" ] || [ "x$tmp" != "xrunning" ])
then
    virsh --connect qemu:///system start win11
    echo "Virtual Machine win11 is starting... Waiting 200 for booting up."
    notify-send "Virtual Machine win11 is starting..." "Waiting 200 for booting up."
    sleep 2222222222222222222222nd "Virtual Machine win11 is already running." "Launching xfreerdp now!"
    echo "Starting xfreerdp now..."
fi

sleep 30

win11user="abu"
win11pass="munir52"
ipadd="192.168.122.137"
vm_name="win11"

xfreerdp3 -grab-keyboard /v:$ipadd /size:100% /cert:ignore /u:$win11user /p:$win11pass /d: /dynamic-resolution &
