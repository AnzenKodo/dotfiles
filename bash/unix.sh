# Load Default Profile
#===============================================================================

# To slove __git_ps1 not found error ==========================================

if [ -f /usr/share/git/git-prompt.sh ]; then
    source /usr/share/git/git-prompt.sh
fi

# Load ========================================================================

export XDG_CACHE_HOME="$HOME/.cache"

last_dir_state_path="$XDG_STATE_HOME/last-dir.txt"
bash_state_path=$XDG_STATE_HOME/bash
source ~/Dotfiles/bash/default.sh

# Set Variables
#===============================================================================

# Path =========================================================================

export PATH="$HOME/Applications/AppImages:$HOME/Applications/bin"\
":$HOME/Code/Miniapps/bin:$HOME/Code/Tools/bin"\
":$XDG_DATA_HOME/python/bin:$CARGO_HOME/bin"\
":$PATH"

# Support XDG Base Directory ===================================================

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_DOWNLOAD_DIR="$HOME/Downloads"
export XDG_DOCUMENTS_DIR="$HOME/Documents"
export XDG_MUSIC_DIR="$HOME/Music"
export XDG_PICTURES_DIR="$HOME/Pictures"
export XDG_VIDEOS_DIR="$HOME/Videos"

# Application Variables ========================================================

# export PAGER="bat"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export CALCHISTFILE="$XDG_CACHE_HOME"/calc_history

export GOPATH="$XDG_DATA_HOME"/go
export GOMODCACHE="$XDG_CACHE_HOME"/go/mod
export PYTHON_HISTORY=$XDG_STATE_HOME/python/history
export PYTHONPYCACHEPREFIX=$XDG_CACHE_HOME/python
export PYTHONUSERBASE=$XDG_DATA_HOME/python
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup

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


alias rmr="gtrash restore"
alias rme="gtrash find --rm ."
alias rsync="rsync --hard-links --archive --recursive --update --executability \
    --verbose --human-readable --progress"
alias rsync_git="rsync --filter='dir-merge,- .gitignore' --delete"
alias ctags_system="ctags -R -f ~/Dotfiles/Desktop/nvim/system.tags /usr/include/"
alias rclone="rclone --config=$HOME/Drive/Dotfiles/rclone.conf"

# Functions
#===============================================================================

server_backup()
{
    rsync_git ~/Code Gangnam@34.41.58.206:~/
    rsync_git ~/Drive Gangnam@34.41.58.206:~/
    rsync_git ~/Dotfiles Gangnam@34.41.58.206:~/
    rsync --exclude="Archive" --exclude="Deb" --exclude="AppImages" --exclude="clang" --delete ~/Applications Gangnam@34.41.58.206:~/
}
