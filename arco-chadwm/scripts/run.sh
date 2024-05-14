#!/bin/sh


function run {
 if ! pgrep $1 ;
  then
    $@&
  fi
}


run "nm-applet"
run "xfce4-power-manager"
run "blueberry-tray"
run "/usr/lib/xfce4/notifyd/xfce4-notifyd"
run "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"


picom &
run "numlockx on"
run "volumeicon"
#run "pa-applet"
sxhkd -c ~/dotfiles/sxhkd/sxhkdrc &
feh --bg-fill ~/.config/arco-chadwm/wallpaper/chadwm1.jpg &
#wallpaper for other Arch based systems
#feh --bg-fill /usr/share/archlinux-tweak-tool/data/wallpaper/wallpaper.png &
#run applications from startup
run "discord"
#run "telegram-desktop"
#run "/usr/bin/octopi-notifier"

xautolock -time 10 -locker slock &

pkill bar.sh
~/dotfiles/arco-chadwm/scripts/bar.sh &
while type chadwm >/dev/null; do chadwm && continue || break; done
