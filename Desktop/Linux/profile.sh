# Load Global Profile
#===============================================================================

# Path =========================================================================

export PATH="$HOME/Applications/AppImages:$HOME/Applications/bin"\
":$HOME/Code/Miniapps/bin:$HOME/Code/Tools/bin"\
":$XDG_DATA_HOME/python/bin:$CARGO_HOME/bin"\
":$PATH"

# To slove __git_ps1 not found error ==========================================

if [ -f /usr/share/git/git-prompt.sh ]; then
    source /usr/share/git/git-prompt.sh
fi

# Load ========================================================================

export XDG_CACHE_HOME="$HOME/.cache"
last_dir_path="$XDG_CACHE_HOME/last-dir.txt"
source ~/Dotfiles/Desktop/profile.sh

# Set Variables
#===============================================================================

# Support XDG Base Directory ===================================================

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_DOWNLOAD_DIR="$HOME/Downloads"
export XDG_DOCUMENTS_DIR="$HOME/Documents"
export XDG_MUSIC_DIR="$HOME/Music"
export XDG_PICTURES_DIR="$HOME/Pictures"
export XDG_VIDEOS_DIR="$HOME/Videos"

# History ======================================================================

HISTFILE=$XDG_STATE_HOME/bash/history

# Application Variables ========================================================

export GTK2_RC_FILES=~/Dotfiles/Desktop/gtk2rc
export ICEAUTHORITY=$XDG_CACHE_HOME/ICEauthority
# export XAUTHORITY=$XDG_RUNTIME_DIR/Xauthority
export ERRFILE="$XDG_CACHE_HOME/X11/xsession-errors"
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export CALCHISTFILE="$XDG_CACHE_HOME"/calc_history
export FCEUX_HOME="$XDG_CONFIG_HOME"/fceux
export ASPELL_CONF="personal $HOME/Dotfiles/Desktop/en.pws; repl $XDG_DATA_HOME/aspell.en.prepl"
# export PAGER="bat"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export AW_SYNC_DIR="~/Drive/Dotfiles/ActivityWatch"
export WINEPREFIX="$XDG_DATA_HOME"/wineprefixes/default

export GOPATH="$XDG_DATA_HOME"/go
export GOMODCACHE="$XDG_CACHE_HOME"/go/mod
export CPATH=/usr/include/freetype2/:$CPATH
export PYTHON_HISTORY=$XDG_STATE_HOME/python/history
export PYTHONPYCACHEPREFIX=$XDG_CACHE_HOME/python
export PYTHONUSERBASE=$XDG_DATA_HOME/python
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export WGETRC="$XDG_CONFIG_HOME/wgetrc"
export JAVA_HOME="$HOME/Code/Tools/jdk-24.0.1"

# Source Files
#===============================================================================

eval "$(gtrash completion bash)"

# Alias
#===============================================================================

alias rm="gtrash put"
alias wget="wget --hsts-file=\"$XDG_CACHE_HOME/wget-hsts\""

# Alias Functions ==============================================================

_open_complete()
{
    local cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=( $(compgen -c "$cur") )
}

ask_and_run()
{
    read -p "Do you want to proceed? (y/n): " ans
    case $ans in
        [Yy]* )
            eval "$@" ;;
        * )
            echo "Operation cancelled." ;;
    esac
}

o()
{
    "$@" > /dev/null 2>&1 & disown
}
oe()
{
    "$@" > /dev/null 2>&1 & disown
    exit
}
complete -F _open_complete o
complete -F _open_complete oe

# Power Management =============================================================

alias poweroff="ask_and_run sudo poweroff"
alias reboot="ask_and_run sudo reboot"
alias logout="ask_and_run xfce4-session-logout"
#alias lock

alias rmr="gtrash restore"
alias rme="gtrash find --rm ."
alias rsync="rsync --hard-links --archive --recursive --update --executability \
    --verbose --human-readable --progress"
alias rsync_git="rsync --filter='dir-merge,- .gitignore' --delete"
alias ctags_system="ctags -R -f ~/Dotfiles/Desktop/nvim/system.tags /usr/include/"

# Functions
#===============================================================================

dotfile_link()
{
    ln -sfv ~/Dotfiles/Desktop/Linux/$1 $2
}


alias rclone="rclone --config=$HOME/Drive/Dotfiles/rclone.conf"
backup()
{
    opml_to_feed ~/Drive/Dotfiles/podcast.opml ~/Drive/Notes/Feed.md

    cd ~/Dotfiles
    push "Backup from Linux Desktop"
    cd -

    rclone \
        bisync ~/Drive Personal: \
        --exclude buffers/** \
        --check-first --metadata --checksum --download-hash --verbose \
        --compare size,modtime,checksum \
        --resync

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

clean()
{
    sudo fstrim -a -v
}

net_temp_on()
{
    nmcli networking on
    # Wait for 5 minutes (300 seconds)
    sleep 300
    # Disable internet
    nmcli networking off
}

ctags-system()
{
    ctags --c-kinds=+p --fields=+l --sort=yes -f $XDG_CACHE_HOME/ctags/system.tags \
        /usr/include/stdio.h /usr/include/stdlib.h /usr/include/stdint.h \
        /usr/include/string.h /usr/include/time.h \
        -R /usr/include/sys /usr/include/xcb /usr/include/GLES2/ /usr/include/EGL
}

# Added Terminal Feature's
#==============================================================================

if [ "$PWD" = "$HOME" ]; then
    cd "$(cat $XDG_CACHE_HOME/last-dir.txt)"
fi
