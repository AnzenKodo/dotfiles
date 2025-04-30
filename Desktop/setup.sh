rm -rf ~/Public ~/Desktop ~/Templates
mkdir ~/Drive ~/Applications ~/Applications/bin ~/Code ~/Pictures/Screenshots

sudo apt purge xf* node* firefox-esr gimp* libreoffice* refracta* \
atril exfalso htop system-config-printer synaptic xscan mutt desktop-base \
slim lynx gnome-keyring

sudo rm /usr/lib/python3.11/EXTERNALLY-MANAGED

sudo apt install git unzip xclip unar \
thunar thunar-archive-plugin \ # Files
mousepad \ # Editor
ristretto \ # Image Viewer
qpdfview \ # Pdf Viewer
timeshift \ # Backup
rofi \ # Menu
calc \ # Calculator
keepassxc \ # Password
xtodo \ # For typeing
fonts-noto fonts-noto-color-emoji fonts-dejavu \ # Fonts
gparted \ # Disk Manger
pm-utils xfce4-power-manager \ # Power Management tools
playerctl \ # Media Controller
brightnessctl \ # Brightness Controller
gvfs-backends \ # FTP support for thunar
gnome-themes-extra-data python-is-python3 command-not-found xdg-desktop-portal-gtk

sudo apt autopurge

sudo update-rc.d -f alsa-utils defaults
sudo update-rc.d -f acpi-fakekey disable
sudo update-rc.d -f bluetooth disable
sudo update-rc.d -f exim4 disable
sudo update-rc.d -f gdomap disable
sudo update-rc.d -f live-config disable
sudo update-rc.d -f live-tools disable
sudo update-rc.d -f rsync disable
sudo update-rc.d -f speech-dispatcher disable
sudo update-rc.d -f ssh disable
sudo update-rc.d -f tor disable
sudo update-rc.d -f vsftpd disable

ln -sf $DOTFILES/Desktop/profile.sh $HOME/.bashrc
ln -sf $DOTFILES/Desktop/profile.sh $HOME/.profile

mkdir $XDG_CONFIG_HOME/fontconfig
ln -sf $DOTFILES/fonts.conf $XDG_CONFIG_HOME/fontconfig/

mkdir $XDG_STATE_HOME/bash
mkdir $XDG_CACHE_HOME/X11

ln -sf $DOTFILES/fonts $XDG_DATA_HOME
ln -sf $DOTFILES/Desktop/themes $XDG_DATA_HOME
ln -sf $DOTFILES/Desktop/icons $XDG_DATA_HOME

ln -srf $DOTFILES/Desktop/activitywatch $XDG_CONFIG_HOME

ln -sf $DOTFILES/Desktop/xfce4 $XDG_CONFIG_HOME
ln -sf $DOTFILES/Desktop/ghostty $XDG_CONFIG_HOME
ln -sf $DOTFILES/Desktop/zed $XDG_CONFIG_HOME
ln -sf $DOTFILES/Desktop/git $XDG_CONFIG_HOME
ln -sf $DOTFILES/Desktop/rofi $XDG_CONFIG_HOME
ln -sf ~/Drive/Dotfiles/keepassxc $XDG_CONFIG_HOME

# sudo rm /usr/local/bin
# sudo ln -srf $USR_APPLICATIONS_DIR/bin /usr/local/bin

# Archive ======================================================================

# ln -sf $DOTFILES/Desktop/focus-editor $XDG_CONFIG_HOME

# mkdir $XDG_CONFIG_HOME/alacritty
# ln -sf $DOTFILES/alacritty.toml $XDG_CONFIG_HOME/alacritty/alacritty.toml

# ln -sf $DOTFILES/nvim ~/.config/nvim

# ln -srf $DOTFILES/i3 $XDG_CONFIG_HOME/i3

# ln -sf $DOTFILES/xournalpp/* $XDG_CONFIG_HOME/xournalpp/

# ln -sf $DOTFILES/dbus-1 $XDG_DATA_HOME

# mkdir $XDG_CONFIG_HOME/runst
# ln -sf $DOTFILES/runst.toml $XDG_CONFIG_HOME/runst/runst.toml

# ln -sf $DOTFILES/zed $XDG_CONFIG_HOME/zed
