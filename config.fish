# -----------------------------------------------------
# ~/.config/fish/config.fish (Fish equivalent of .bashrc)
# -----------------------------------------------------

# ASCII Art Header
#   | |__   __ _ ___| |__  _ __ ___ 
#   | '_ \ / _` / __| '_ \| '__/ __|
#  _| |_) | (_| \__ \ | | | | | (__ 
# (_)_.__/ \__,_|___/_| |_|_|  \___|
# -----------------------------------------------------

# -----------------------------------------------------
# ENVIRONMENT VARIABLES
# -----------------------------------------------------
# Set the PATH variable properly in Fish
# Ensure we are adding to the current $PATH and not overwriting it
set -x PATH /usr/lib/ccache/bin/ /home/abu/.local/bin /home/abu/bin $PATH

# History file sizes
set -x HISTFILESIZE 10000
set -x HISTSIZE 500

set -x OLLAMA_API_BASE "http://localhost:11434"

# -----------------------------------------------------
# ALIASES (Functions in Fish)
# -----------------------------------------------------

# System Management
alias sf='sudo setfont ter-128b'
alias c='clear'
alias shutdown='sudo shutdown -P now'
alias reboot='sudo shutdown -r now'
alias logout='pkill -TERM chadwm'
alias update='sudo dnf update && sudo dnf upgrade -y'
alias dnfc='sudo dnf clean all'
alias dnfp='sudo dnf autoremove -y'
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias setkb='setxkbmap gb; echo "Keyboard set back to gb."'
alias unlock="sudo rm /var/lib/pacman/db.lck"
alias rmpacmanlock="sudo rm /var/lib/pacman/db.lck"
alias gui="sudo systemctl isolate graphical.target"

# File and Directory Management
alias v='nvim'
alias shot='scrot -d 3 -c -z -u'
alias shotsel='scrot -s'
alias dot="cd ~/dotfiles"
alias wdownload='sudo mount --bind ~/Downloads ~/.local/share/waydroid/data/media/0/Download'
alias cd..="cd .."
alias hs="cd ~/ && ls"
alias up="cd .."
alias home="cd ~/"
alias root="sudo su"
alias mkdir="mkdir -pv"
alias hist="history"
alias jobs="jobs -l"
alias path="echo -e (string split : $PATH)"

# Network Management
alias wifi='nmtui'
alias ports="netstat -tulanp"
alias whatismyip="whatsmyip"

# Window Managers
alias Qtile='startx'
alias QtileWayland='qtile start -b wayland'
alias xfce='exec startxfce4'
alias chadwm='startx ~/dotfiles/arco-chadwm/scripts/run.sh'
alias flexidwm='startx ~/dotfiles/flexi/autostart.sh'

# Docker Management
alias dps='docker ps -a'
alias dimages='docker images'
alias dlogs='docker logs'
alias dexec='docker exec -it'
alias drm='docker rm'
alias drmi='docker rmi'
alias dstopall='docker stop (docker ps -a -q)'
alias drmall='docker rm (docker ps -a -q)'
alias dprune='docker system prune -a'
alias dcup='docker-compose up -d'
alias ds='docker start'

# SSH Management
alias sshs='sudo service sshd start'
alias sshstatus='sudo service sshd status'

# Git Management
alias gs="git status"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
alias gpl="git pull"
alias gst="git stash"
alias gsp="git stash; git pull"
alias gcheck="git checkout"
alias gcom="git add .; git commit -m '$argv'"
alias lazyg="git add .; git commit -m '$argv'; git push"

# Virtual Machine Management
alias vm='~/private/launchvm.sh'
alias lg='~/dotfiles/scripts/looking-glass.sh'
alias vmstart='virsh --connect qemu:///system start win11'
alias vmstop='virsh --connect qemu:///system destroy win11'
alias vmstatus='virsh --connect qemu:///system list --all'

# Config Files Management
alias confq='nvim ~/dotfiles/qtile/config.py'
alias confb='nvim ~/dotfiles/.bashrc-personal-fedora'
alias confp='nvim ~/dotfiles/.setup/install-packages.sh'
alias catb='cat ~/dotfiles/.bashrc-personal-fedora'
alias notes='vim ~/notes.txt'

# Grep and ls Aliases
alias grep="grep --color=auto"
alias l.="ls -d .* --color=auto"
alias ls="ls -C --color=auto"
alias lm="ls -lhA --color=auto | more"
alias ll="ls -lh --color=auto"
alias la="ls -lhA --color=auto"
alias lar="ls -lhAR --color=auto | more"
alias lcr="ls -CAR --color=auto | more"
alias lx='ls -la --color | grep "^d" && ls -la | grep "^-" && ls -la | grep "^l"'

# Time Related Aliases
alias now="date +\"%T\""
alias nowtime="date +\"%T\""
alias nowdate="date +\"%d-%m-%Y\""

# Miscellaneous Aliases
alias df='df -h'
alias lock='xscreensaver-command -lock'
alias matrix='cat /dev/urandom'
alias removesvn='rm -rf (find . -type d -name .svn)'
alias syslog='sudo cat /var/log/messages'
alias beets='beet import ~/Music'
alias update-fc='sudo fc-cache -fv'
alias speedtest='speedtest-cli'
alias fix-thorium='rm -f /home/abu/.config/thorium/lockfile /home/abu/.config/thorium/SingletonLock /home/abu/.config/thorium/SingletonSocket /home/abu/.config/thorium/SingletonCookie'
alias yt="youtube-dl -ci"
alias ytp="youtube-dl -tAci"
alias ytm="youtube-dl -cif 251"

# Custom Scripts
alias gr='python ~/dotfiles/scripts/growthrate.py'
alias ChatGPT='python ~/mychatgpt/mychatgpt.py'
alias chat='python ~/mychatgpt/mychatgpt.py'
alias ascii='~/dotfiles/scripts/figlet.sh'

# -----------------------------------------------------
# FUNCTIONS
# -----------------------------------------------------

# Network interface management
function find_interface
    set default_interface "enp1s0"
    set interface_name (ip -4 addr show up | grep -E '^[0-9]+: ' | grep -v 'docker0' | head -n 1 | awk '{print $2}' | sed 's/://')

    if test -z "$interface_name"
        echo "No active Ethernet interfaces found. Using default interface '$default_interface'."
        set interface_name "$default_interface"
    end
    
    echo "$interface_name"
end

# Alias functions for IP management
function set_ip
    set interface_name (find_interface)
    set current_ip (ip -4 addr show "$interface_name" | grep "inet 10.0.1.200")
    if test -z "$current_ip"
        echo "Setting IP 10.0.1.200/24 on interface: $interface_name"
        sudo ip addr add 10.0.1.200/24 dev "$interface_name"
    else
        echo "IP 10.0.1.200/24 is already set on interface: $interface_name"
    end
end

function reset_ip
    set interface_name (find_interface)
    set current_ip (ip -4 addr show "$interface_name" | grep "inet 10.0.1.200")
    if test -n "$current_ip"
        echo "Removing IP 10.0.1.200/24 from interface: $interface_name"
        sudo ip addr del 10.0.1.200/24 dev "$interface_name"
    else
        echo "IP 10.0.1.200/24 is not set on interface: $interface_name"
    end
end

# Unmute and max volume for Master
function unmute-all
    amixer sset Master unmute
    amixer sset Master 100%
end

# Copy file with a progress bar
function cpp
    strace -q -ewrite cp -- "$argv[1]" "$argv[2]" 2>&1 | awk '
        {count += $NF; if (count % 10 == 0) {
            percent = count / total_size * 100;
            printf "%3d%% [", percent;
            for (i=0;i<=percent;i++) printf "=";
            printf ">";
            for (i=percent;i<100;i++) printf " ";
            printf "]\r";
        }} END { print "" }' total_size=(stat -c '%s' "$argv[1]") count=0
end

# Show current network information
function netinfo
    echo "--------------- Network Information ---------------"
    /sbin/ifconfig | awk /'inet addr/ {print $2}'
    echo ""
    /sbin/ifconfig | awk /'Bcast/ {print $3}'
    echo ""
    /sbin/ifconfig | awk /'inet addr/ {print $4}'
    /sbin/ifconfig | awk /'HWaddr/ {print $4}'
end



#give the list of all installed desktops - xsessions desktops
alias xd="ls /usr/share/xsessions"
alias xdw="ls /usr/share/wayland-sessions"


set fish_color_autosuggestion "#969896"
set fish_color_cancel -r
set fish_color_command "#0782DE"
set fish_color_comment "#f0c674"
set fish_color_cwd "#008000"
set fish_color_cwd_root red
set fish_color_end "#b294bb"
set fish_color_error "#fb4934"
set fish_color_escape "#fe8019"
set fish_color_history_current --bold
set fish_color_host "#85AD82"
set fish_color_host_remote yellow
set fish_color_match --background=brblue
set fish_color_normal normal
set fish_color_operator "#fe8019"
set fish_color_param "#81a2be"
set fish_color_quote "#b8bb26"
set fish_color_redirection "#d3869b"
set fish_color_search_match bryellow background=brblack
set fish_color_selection white --bold background=brblack
set fish_color_status red
set fish_color_user brgreen
set fish_color_valid_path --underline
set fish_pager_color_completion normal
set fish_pager_color_description "#B3A06D" yellow
set fish_pager_color_prefix normal --bold underline
set fish_pager_color_prefix white --bold --underline
set fish_pager_color_progress brwhite --background=cyan
set fish_color_search_match --background="#60AEFF"
