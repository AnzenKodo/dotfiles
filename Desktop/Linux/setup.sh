rm -rf ~/Public ~/Desktop ~/Templates

rofi \ # Menu

sudo xbps-remove firefox

sudo xbps-install xtools xclip git \
xfce4-clipman-plugin \ # Clipboard
xfce4-screenshooter \ # Screenshort
zip unzip xarchiver thunar-archive-plugin \ # Archive
lightdm-gtk-greeter-settings \ # Display Manager
noto-fonts-emoji noto-fonts-ttf-extra noto-fonts-cjk \ # Fonts
playerctl # Media Controller
calc \ # Calculator
evince \ # Pdf Viewer

ln -sfv ~/Dotfiles/Desktop/Linux/profile.sh $HOME/.bashrc

mkdir $XDG_STATE_HOME/bash
touch $XDG_STATE_HOME/bash/history
mkdir $XDG_CACHE_HOME/X11

rm $XDG_DATA_HOME/applications
ln -sfv ~/Applications/Mime $XDG_DATA_HOME/applications
ln -sfv ~/Applications/Mime/icons $XDG_DATA_HOME/icons
ln -sfv ~/Dotfiles/fonts $XDG_DATA_HOME

ln -sfv ~/Applications/Mime/mimeapps.list $XDG_CONFIG_HOME/mimeapps.list
ln -sfv ~/Dotfiles/Desktop/activitywatch $XDG_CONFIG_HOME
dotfile_link xfce4 $XDG_CONFIG_HOME
ln -srf ~/Dotfiles/Desktop/ghostty $XDG_CONFIG_HOME
ln -srf ~/Dotfiles/Desktop/git $XDG_CONFIG_HOME
ln -srf ~/Dotfiles/Desktop/focus-editor $XDG_CONFIG_HOME
ln -sfv ~/Drive/Dotfiles/Desktop/keepassxc $XDG_CONFIG_HOME
ln -sfv ~/Dotfiles/Desktop/nvim $XDG_CONFIG_HOME

sudo rm /usr/local/bin
sudo ln -srf $USR_APPLICATIONS_DIR/bin /usr/local/bin

# Archive
#===============================================================================

# mkdir $XDG_CONFIG_HOME/alacritty
# ln -sf $DOTFILES/alacritty.toml $XDG_CONFIG_HOME/alacritty/alacritty.toml

# ln -srf $DOTFILES/i3 $XDG_CONFIG_HOME/i3

# ln -sf $DOTFILES/xournalpp/* $XDG_CONFIG_HOME/xournalpp/

# ln -sf $DOTFILES/dbus-1 $XDG_DATA_HOME

# mkdir $XDG_CONFIG_HOME/runst
# ln -sf $DOTFILES/runst.toml $XDG_CONFIG_HOME/runst/runst.toml

# ln -sf $DOTFILES/zed $XDG_CONFIG_HOME/zed
