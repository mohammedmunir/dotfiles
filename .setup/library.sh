#!/bin/bash
#  _     _ _                           
# | |   (_) |__  _ __ __ _ _ __ _   _  
# | |   | | '_ \| '__/ _` | '__| | | | 
# | |___| | |_) | | | (_| | |  | |_| | 
# |_____|_|_.__/|_|  \__,_|_|   \__, | 
#                               |___/  
#  
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 

# ------------------------------------------------------
# Function: Is package installed
# ------------------------------------------------------
_isInstalledPacman() {
    package="$1";
    check="$(sudo pacman -Qs --color always "${package}" | grep "local" | grep "${package} ")";
    if [ -n "${check}" ] ; then
        echo 0; #'0' means 'true' in Bash
        return; #true
    fi;
    echo 1; #'1' means 'false' in Bash
    return; #false
}

_isInstalledYay() {
    package="$1";
    check="$(yay -Qs --color always "${package}" | grep "local" | grep "${package} ")";
    if [ -n "${check}" ] ; then
        echo 0; #'0' means 'true' in Bash
        return; #true
    fi;
    echo 1; #'1' means 'false' in Bash
    return; #false
}

# ------------------------------------------------------
# Function Install all packages if not installed
# ------------------------------------------------------
_installPackagesPacman() {
    toInstall=();

    for pkg; do
        if [[ $(_isInstalledPacman "${pkg}") == 0 ]]; then
            echo "${pkg} is already installed.";
            continue;
        fi;

        toInstall+=("${pkg}");
    done;

    if [[ "${toInstall[@]}" == "" ]] ; then
        # echo "All pacman packages are already installed.";
        return;
    fi;

    printf "Packages not installed:\n%s\n" "${toInstall[@]}";
    sudo pacman --noconfirm -S "${toInstall[@]}";
}

_installPackagesYay() {
    toInstall=();

    for pkg; do
        if [[ $(_isInstalledYay "${pkg}") == 0 ]]; then
            echo "${pkg} is already installed.";
            continue;
        fi;

        toInstall+=("${pkg}");
    done;

    if [[ "${toInstall[@]}" == "" ]] ; then
        # echo "All AUR packages are already installed.";
        return;
    fi;

    printf "AUR packages not installed:\n%s\n" "${toInstall[@]}";
    yay --noconfirm -S "${toInstall[@]}";
}

# ------------------------------------------------------
# Function Remove packages if installed
# ------------------------------------------------------
_removePackagesPacman() {
    toRemove=();

    for pkg; do
        if [[ $(_isInstalledPacman "${pkg}") == 1 ]]; then
            echo "${pkg} is not installed.";
            continue;
        fi;

        toRemove+=("${pkg}");
    done;

    if [[ "${toRemove[@]}" == "" ]] ; then
        # echo "No pacman packages to remove.";
        return;
    fi;

    printf "Packages to be removed:\n%s\n" "${toRemove[@]}";
    sudo pacman --noconfirm -R "${toRemove[@]}";
}

_removePackagesYay() {
    toRemove=();

    for pkg; do
        if [[ $(_isInstalledYay "${pkg}") == 1 ]]; then
            echo "${pkg} is not installed.";
            continue;
        fi;

        toRemove+=("${pkg}");
    done;

    if [[ "${toRemove[@]}" == "" ]] ; then
        # echo "No AUR packages to remove.";
        return;
    fi;

    printf "AUR packages to be removed:\n%s\n" "${toRemove[@]}";
    yay --noconfirm -R "${toRemove[@]}";
}

# ------------------------------------------------------
# Create symbolic links
# ------------------------------------------------------
_installSymLink() {
    name="$1"
    symlink="$2";
    linksource="$3";
    linktarget="$4";
    
    if [ -L "${symlink}" ]; then
        rm ${symlink}
        ln -s ${linksource} ${linktarget} 
        echo "Symlink ${linksource} -> ${linktarget} created."
    else
        if [ -d ${symlink} ]; then
            rm -rf ${symlink}/ 
            ln -s ${linksource} ${linktarget}
            echo "Symlink for directory ${linksource} -> ${linktarget} created."
        else
            if [ -f ${symlink} ]; then
                rm ${symlink} 
                ln -s ${linksource} ${linktarget} 
                echo "Symlink to file ${linksource} -> ${linktarget} created."
            else
                ln -s ${linksource} ${linktarget} 
                echo "New symlink ${linksource} -> ${linktarget} created."
            fi
        fi
    fi
}
