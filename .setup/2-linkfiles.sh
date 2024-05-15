# ------------------------------------------------------
# Install dotfiles
# ------------------------------------------------------

source library.sh

# name="$1"
# symlink="$2";
# linksource="$3";
# linktarget="$4";
    
_installSymLink nvim ~/.config/nvim ~/dotfiles/nvim/ ~/.config
_installSymLink .bashrc-personal ~/.bashrc-personal ~/dotfiles/.bashrc-personal ~/.bashrc-personal
_installSymLink starship ~/.config/starship.toml ~/dotfiles/starship/starship.toml ~/.config/starship.toml
_installSymLink rofi ~/.config/rofi ~/dotfiles/rofi/ ~/.config
_installSymLink .gtkrc-2.0 ~/.gtkrc-2.0 ~/dotfiles/gtk/.gtkrc-2.0 ~/.gtkrc-2.0
_installSymLink .Xresources ~/.Xresources ~/dotfiles/gtk/.Xresources ~/.Xresources
_installSymLink gtk-3.0 ~/.config/gtk-3.0 ~/dotfiles/gtk/gtk-3.0/ ~/.config/   

echo "Symbolic links created."
echo ""
