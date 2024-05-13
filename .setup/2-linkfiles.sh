# ------------------------------------------------------
# Install dotfiles
# ------------------------------------------------------

source library.sh

# name="$1"
# symlink="$2";
# linksource="$3";
# linktarget="$4";
    
_installSymLink nvim ~/.config/nvim ~/dotfiles/nvim/ ~/.config
_installSymLink .xinitrc ~/.xinitrc ~/dotfiles/qtile/.xinitrc ~/.xinitrc   
_installSymLink .bashrc-personal ~/.bashrc-personal ~/dotfiles/.bashrc-personal ~/.bashrc-personal

echo "Symbolic links created."
echo ""
