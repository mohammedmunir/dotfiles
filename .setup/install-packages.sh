source library.sh

packagesPacman=(
    "neovim" 
    "mpv" 
    "freerdp" 
    "figlet" 
    "vlc" 
    "brightnessctl"
    "qbittorrent"
    "torbrowser-launcher"
    "fastfetch"
);

packagesYay=(
    "thorium-browser-bin" 
    "localsend-bin"
    "zoxide"
);



# ------------------------------------------------------
# Install required packages
# ------------------------------------------------------
echo -e "${GREEN}"
cat <<"EOF"
 ___           _        _ _                    _                         
|_ _|_ __  ___| |_ __ _| | |  _ __   __ _  ___| | ____ _  __ _  ___  ___ 
 | || '_ \/ __| __/ _` | | | | '_ \ / _` |/ __| |/ / _` |/ _` |/ _ \/ __|
 | || | | \__ \ || (_| | | | | |_) | (_| | (__|   < (_| | (_| |  __/\__ \
|___|_| |_|___/\__\__,_|_|_| | .__/ \__,_|\___|_|\_\__,_|\__, |\___||___/
                             |_|                         |___/           

EOF
echo -e "${NONE}"
_installPackagesPacman "${packagesPacman[@]}";
_installPackagesYay "${packagesYay[@]}";
echo ""
