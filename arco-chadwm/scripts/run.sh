#!/bin/sh

# Function to run a command if it's not already running
run() {
  if ! pgrep $1 ; then
    $@&
  fi
}

# System tray and notification applications
run "nm-applet"                              # Network manager applet
#run "variety"                                # Wallpaper changer
run "xfce4-power-manager"                    # Power management
run "blueberry-tray"                         # Bluetooth manager
run "/usr/lib/xfce4/notifyd/xfce4-notifyd"   # Notification daemon
run "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"  # Polkit authentication agent
run "/usr/libexec/polkit-gnome-authentication-agent-1"           # Polkit authentication agent (Fedora)
run "nm-applet"  # Network manager applet for Wi-Fi and network management
blueman-applet &


# Compositor and utility applications
picom &                                      # Compositor for transparency and effects
run "numlockx on"                            # Enable numlock                           
run "flameshot"                              # Screenshot tool
# run "pa-applet"                            # Pulseaudio applet (optional)

# Keybindings and wallpaper
sxhkd -c ~/dotfiles/sxhkd/sxhkdrc &          # Simple X hotkey daemon
feh --bg-fill /usr/share/backgrounds/archlinux/arch-wallpaper.jpg &  # Set wallpaper
feh --bg-fill /usr/share/backgrounds/arcolinux/arco-wallpaper.jpg &  # Set secondary wallpaper

# Auto-lock screen after inactivity
xautolock -time 10 -locker slock &           # Auto-lock after 10 minutes

# Start virtual machines
run "virsh --connect qemu:///system start microwin"    # Start Windows 11 VM
run "virsh --connect qemu:///system start ubuntu"      # Start Ubuntu VM

# Kill and restart the bar
pkill bar.sh
~/dotfiles/arco-chadwm/scripts/bar.sh &

# Start xbindkeys for mouse key mappings
xbindkeys &                                   # Start xbindkeys for keybindings

# Volume control icon
volumeicon &

# Start SillyTavern
#cd /home/abu/Documents/Repos/SillyTavern && nohup ./start.sh > /dev/null 2>&1 &

# Launch chadwm in a loop, restart on crash
while type chadwm >/dev/null; do
  chadwm && continue || break
done

