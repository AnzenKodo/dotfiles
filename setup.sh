rm -rf ~/Public ~/Desktop ~/Templates
mkdir ~/Online ~/Apps ~/Apps/bin ~/Code ~/Pictures/Screenshots

sudo apt purge xf* node* firefox-esr gimp* libreoffice* refracta* \
atril exfalso htop system-config-printer synaptic xscan mutt desktop-base \
mousepad slim gparted

sudo rm /usr/lib/python3.11/EXTERNALLY-MANAGED

sudo apt install git unzip xclip unar \
thunar thunar-archive-plugin \ # File Manager
feh \ # Image Viewer
timeshift \ # Backup
dmenu \ # Menu
alacritty \ # Terminal
scrot \ # Screenshot
calc \ # Calculator
keepassxc \ # Password
xtodo \ # For typeing
fonts-noto fonts-noto-color-emoji fonts-dejavu \ # Fonts
gparted \ # Disk Manger
pm-utils xfce4-power-manager \ # Power Management tools
playerctl \ # Media Controller
brightnessctl \ # Brightness Controller
gnome-themes-extra-data python-is-python3 command-not-found xdg-desktop-portal-gtk

# i3-wm i3status i3lock \ # Window Manger

sudo apt autopurge

ln -sf $DOTFILES/profile.sh $HOME/.bashrc
ln -sf $DOTFILES/profile.sh $HOME/.profile

mkdir $XDG_CONFIG_HOME/git/
ln -sf $DOTFILES/git.init $XDG_CONFIG_HOME/git/config

mkdir $XDG_CONFIG_HOME/alacritty
ln -sf $DOTFILES/alacritty.toml $XDG_CONFIG_HOME/alacritty/alacritty.toml

mkdir $XDG_CONFIG_HOME/fontconfig
ln -sf $DOTFILES/fonts.conf $XDG_CONFIG_HOME/fontconfig/

mkdir $XDG_STATE_HOME/bash
mkdir $XDG_CACHE_HOME/X11

ln -sf $DOTFILES/focus-editor/ $XDG_CONFIG_HOME

ln -sf $DOTFILES/fonts $XDG_DATA_HOME
ln -sf $DOTFILES/themes $XDG_DATA_HOME
ln -sf $DOTFILES/icons $XDG_DATA_HOME

ln -sf $DOTFILES/keepassxc $XDG_CONFIG_HOME

ln -sf $DOTFILES/xfce4/ $XDG_CONFIG_HOME

ln -sf $DOTFILES/gtk-4.0/ $XDG_CONFIG_HOME

# sudo rm /usr/local/bin
# sudo ln -srf $USR_APPLICATIONS_DIR/bin /usr/local/bin


# Archive

# ln -sf $DOTFILES/nvim ~/.config/nvim
# ln -srf $DOTFILES/i3 $XDG_CONFIG_HOME/i3
# ln -sf $DOTFILES/xournalpp/* $XDG_CONFIG_HOME/xournalpp/
# ln -sf $DOTFILES/dbus-1 $XDG_DATA_HOME

# mkdir $XDG_CONFIG_HOME/runst
# ln -sf $DOTFILES/runst.toml $XDG_CONFIG_HOME/runst/runst.toml

# ln -sf $DOTFILES/zed $XDG_CONFIG_HOME/zed
