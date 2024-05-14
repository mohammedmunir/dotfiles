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
_installSymLink thunar ~/.config/thunar ~/dotfiles/thunar/ ~/.config

echo "Symbolic links created."
echo ""
