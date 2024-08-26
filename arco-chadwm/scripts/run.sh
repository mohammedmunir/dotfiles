#!/bin/sh


function run {
 if ! pgrep $1 ;
  then
    $@&
  fi
}


run "nm-applet"
run "variety"
run "xfce4-power-manager"
run "blueberry-tray"
run "/usr/lib/xfce4/notifyd/xfce4-notifyd"
run "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
#for fedoa
run "/usr/libexec/polkit-gnome-authentication-agent-1"

picom &
run "numlockx on"
run "volumeicon"
run "flameshot"
#run "pa-applet"
sxhkd -c ~/dotfiles/sxhkd/sxhkdrc &
#feh --bg-fill ~/.config/arco-chadwm/wallpaper/chadwm1.jpg &
feh --bg-fill /usr/share/backgrounds/archlinux/arch-wallpaper.jpg &
feh --bg-fill /usr/share/backgrounds/arcolinux/arco-wallpaper.jpg &
#wallpaper for other Arch based systems
#feh --bg-fill /usr/share/archlinux-tweak-tool/data/wallpaper/wallpaper.png &
#run applications from startup
#run "discord"
#run "telegram-desktop"
#run "/usr/bin/octopi-notifier"

xautolock -time 10 -locker slock &

# # Check if hostname is 'abu-desk'
# if [ "$(hostname)" = "abu-desk" ]; then
#     # Set network port to static IP - gateway
#     sudo ip addr add 10.0.1.200/24 dev enp0s31f6
#     # Start the win11-base VM in the background
#     (
#         vm_name="win11-base"
#         virsh --connect qemu:///system start $vm_name
#     ) &
# fi
run 'virsh --connect qemu:///system start win11-base' &

~/dotfiles/arco-chadwm/scripts/launch_vm.sh &
pkill bar.sh
~/dotfiles/arco-chadwm/scripts/bar.sh &
while type chadwm >/dev/null; do chadwm && continue || break; done

