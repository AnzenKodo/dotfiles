# Load Unix Profile
#===============================================================================

# Load ========================================================================

source ~/Dotfiles/bash/unix.sh

# Functions
#===============================================================================

backup()
{
    git -C ~/Dotfiles pull
    git -C ~/Dotfiles add .
    git -C ~/Dotfiles commit -m "Backup from Windows Desktop"
    git -C ~/Dotfiles push
}
