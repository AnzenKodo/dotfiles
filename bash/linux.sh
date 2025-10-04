# Load Unix Profile
#===============================================================================

# Load ========================================================================

source ~/Dotfiles/bash/unix.sh

# Set Variables
#===============================================================================

# Application Variables ========================================================

export GTK2_RC_FILES=~/Dotfiles/Desktop/gtk2rc
export WGETRC="$XDG_CONFIG_HOME/wgetrc"
export ICEAUTHORITY=$XDG_CACHE_HOME/ICEauthority
# export XAUTHORITY=$XDG_RUNTIME_DIR/Xauthority
export ERRFILE="$XDG_CACHE_HOME/X11/xsession-errors"
export AW_SYNC_DIR="~/Drive/Dotfiles/ActivityWatch"
export WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default64"
export WINEARCH=win64
export CPATH=/usr/include/freetype2/:$CPATH
export JAVA_HOME="$HOME/Code/Tools/jdk-24.0.1"

# Alias
#===============================================================================

# Power Management =============================================================

alias poweroff="ask_and_run sudo poweroff"
alias reboot="ask_and_run sudo reboot"
alias logout="ask_and_run xfce4-session-logout"
#alias lock

# Functions
#===============================================================================

clean()
{
    sudo fstrim -a -v
}

ctags-system()
{
    ctags --c-kinds=+p --fields=+l --sort=yes -f $XDG_CACHE_HOME/ctags/system.tags \
        /usr/include/stdio.h /usr/include/stdlib.h /usr/include/stdint.h \
        /usr/include/string.h /usr/include/time.h \
        -R /usr/include/sys /usr/include/xcb /usr/include/GLES2/ /usr/include/EGL
}

backup()
{
    cd ~/Dotfiles
    push "Backup from Linux Desktop"
    cd -

    rclone \
        bisync ~/Drive Personal: \
        --exclude buffers/** \
        --check-first --metadata --checksum --download-hash --verbose \
        --compare size,modtime,checksum
        # --resync

    # cd ~/Code/anzenkodo.github.io
    # echo $RANDOM > ~/Code/anzenkodo.github.io/site_checksum.txt
    # push "Updated Notes"
    # cd -
}

server_backup()
{
    rsync_git ~/Code Gangnam@34.41.58.206:~/
    rsync_git ~/Drive Gangnam@34.41.58.206:~/
    rsync_git ~/Dotfiles Gangnam@34.41.58.206:~/
    rsync --exclude="Archive" --exclude="Deb" --exclude="AppImages" --exclude="clang" --delete ~/Applications Gangnam@34.41.58.206:~/
}
