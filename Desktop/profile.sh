# Set Variables
#===============================================================================

# Support XDG Base Directory ===================================================

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_DOWNLOAD_DIR="$HOME/Downloads"
export XDG_DOCUMENTS_DIR="$HOME/Documents"
export XDG_MUSIC_DIR="$HOME/Music"
export XDG_PICTURES_DIR="$HOME/Pictures"
export XDG_VIDEOS_DIR="$HOME/Videos"

# Path =========================================================================

export PATH="~/Applications/AppImages:~/Applications/bin"\
":~/Code/miniapps/bin"\
":~/Applications/ffmpeg:~/Applications/jdk-23/bin"\
":$XDG_DATA_HOME/python/bin:$CARGO_HOME/bin:~/Applications/clang/bin"\
":~/Applications/codelldb/adapter/codelldb"\
":$PATH"

# Custom Application Variables =================================================

export TERMINAL="ghostty"
export EDITOR="nvim"
export BROWSER="brave --disable-features=OutdatedBuildDetector"
export FILES="thunar"
export OFFICE="onlyoffice"
export PASSWORD_MANAGER="keepassxc"

# Application Variables ========================================================

export GTK2_RC_FILES=~/Dotfiles/Desktop/gtk2rc
export ICEAUTHORITY=$XDG_CACHE_HOME/ICEauthority
# export XAUTHORITY=$XDG_RUNTIME_DIR/Xauthority
export ERRFILE="$XDG_CACHE_HOME/X11/xsession-errors"
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export CALCHISTFILE="$XDG_CACHE_HOME"/calc_history
export FCEUX_HOME="$XDG_CONFIG_HOME"/fceux
export ASPELL_CONF="personal $HOME/Dotfiles/Desktop/en.pws; repl $XDG_DATA_HOME/aspell.en.prepl"
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

# Shell Variables
#===============================================================================

# Prompt =======================================================================

PS1='\n\[\e[38;2;251;73;52m\]\h\[\e[0m\]@\[\e[38;2;250;189;47m\]\u\[\e[0m\]:\[\e[38;2;125;174;163m\]\w\[\e[38;2;184;187;38m\]${PS1_CMD1}\n\[\e[0m\]\\$ '
PROMPT_COMMAND='PS1_CMD1=$(__git_ps1 " (%s)");history -a'

# History ======================================================================

HISTFILE=$XDG_STATE_HOME/bash/history
HISTCONTROL=ignoreboth:erasedups:ignorespace
HISTFILESIZE=
HISTSIZE=
HISTTIMEFORMAT="[%F %T] "

# Source Files
#===============================================================================

eval "$(gtrash completion bash)"
eval "$(zoxide init bash)"
eval "$(fzf --bash)"
export FZF_DEFAULT_OPTS="
  --bind 'tab:down'
  --bind 'shift-tab:up'
"
if [ -n "${GHOSTTY_RESOURCES_DIR}" ]; then
    builtin source "${GHOSTTY_RESOURCES_DIR}/shell-integration/bash/ghostty.bash"
fi

# Alias
#===============================================================================

# Alias Functions ==============================================================

_open_complete() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=( $(compgen -c "$cur") )
}

ask_and_run() {
    read -p "Do you want to proceed? (y/n): " ans
    case $ans in
        [Yy]* )
            eval "$@" ;;
        * )
            echo "Operation cancelled." ;;
    esac
}

o() {
    "$@" > /dev/null 2>&1 & disown
}
oe() {
    "$@" > /dev/null 2>&1 & disown
    exit
}
complete -F _open_complete o
complete -F _open_complete oe

alias bat="bat --theme=gruvbox-dark --style=numbers"
alias btm="btm --color gruvbox"

alias ..="cd .."
alias ~="cd ~"
alias ls="ls -lha --color=always --group-directories-first"
alias mkdir="mkdir -vp"
alias mv="mv -vi"
alias cp="cp -vir"
alias dir="dir --color=always"
alias ln="ln -vi"
alias cat="bat --style=plain --pager=none"
alias grep="rg"
alias diff="bat --style=plain -d"
alias top="btm --battery --enable_cache_memory --enable_gpu_memory --network_use_bytes --network_use_binary_prefix --mem_as_value --show_table_scroll_position"
alias xclip="xclip -selection clipboard"
alias zip="zip -r"
alias tar="tar -v"
alias wget="wget --hsts-file=\"$XDG_CACHE_HOME/wget-hsts\""
alias rm="gtrash put"

# Power Management =============================================================

alias poweroff="ask_and_run sudo poweroff"
alias reboot="ask_and_run sudo reboot"
alias logout="ask_and_run pkill xfce4-session"
alias suspend="sudo pm-suspend"
alias hibernate="sudo pm-hibernate"
#alias quit
#alias lock

alias rmr="gtrash restore"
alias rme="gtrash find --rm ."
alias refresh="source ~/.bashrc"
alias dir_size="du -sh -- * | sort -hr"
alias download="axel --verbose -n"
alias timg="timg -p kitty --title='%b (%wx%h)'"

alias todo="$EDITOR ~/Drive/Notes/Online/Todo.md"
alias feed="$EDITOR ~/Drive/Notes/Feed.md"
alias xcolor="xcolor | xclip"
alias yt="yt-dlp --ffmpeg-location ~/Applications/ffmpeg/ -S ext"
alias yta="yt-dlp --ffmpeg-location ~/Applications/ffmpeg/ --extract-audio --audio-format"
alias tldr="tldr -c"
alias rsync="rsync --hard-links --archive --recursive --update --executability \
    --verbose --human-readable --progress"
alias rsync_git="rsync --filter='dir-merge,- .gitignore' --delete"
alias ctags_system="ctags -R -f ~/Dotfiles/Desktop/nvim/system.tags /usr/include/"

# Functions
#===============================================================================

cd() {
    z "$@"
    pwd > $XDG_CACHE_HOME/last-dir.txt
}

len() {
    str=$@
    echo ${#str}
}

push() {
    git add .
    git commit -m "$1"
    git pull
    git push
}

pastebin()
{
    local url='https://paste.c-net.org/'
    if (( $# )); then
        local file
        for file; do
            curl -s \
                --data-binary @"$file" \
                --header "X-FileName: ${file##*/}" \
                "$url"
        done
    else
        curl -s --data-binary @- "$url"
    fi
}

alias rclone="rclone --config=$HOME/Drive/Dotfiles/rclone.conf"
backup() {
    opml_to_feed ~/Drive/Dotfiles/podcast.opml ~/Drive/Notes/Feed.md

    cd ~/Dotfiles
    push "Backup from Desktop"
    cd -

    rclone \
        bisync ~/Drive Personal: \
        --exclude buffers/** \
        --check-first --metadata --checksum --download-hash --verbose \
        --compare size,modtime,checksum \
        --resync --resync-mode newer \
        --conflict-resolve newer

    cd ~/Code/anzenkodo.github.io
    echo $RANDOM > site_checksum.txt
    push "Updated Notes"
    cd -
}

server_backup() {
    rsync_git ~/Code Gangnam@34.41.58.206:~/
    rsync_git ~/Drive Gangnam@34.41.58.206:~/
    rsync_git ~/Dotfiles Gangnam@34.41.58.206:~/
    rsync --exclude="Archive" --exclude="Deb" --exclude="AppImages" --exclude="clang" --delete ~/Applications Gangnam@34.41.58.206:~/
}

clean() {
    sudo fstrim -a -v
}

project_org() {
    wmctrl -x -r Focus -t 0
    wmctrl -x -r ghostty -t 1
    wmctrl -x -r vscodium -t 1
    wmctrl -x -r brave-browser -t 2
}

project() {
    local proj_path=~/Code/Scuttle
    cd $proj_path

    o focus .
    project_org
}


dotfile_link() {
    ln -sf $HOME/Dotfiles/Desktop/$1 $XDG_CONFIG_HOME
}

compress-mp4() {
    echo ffmpeg -i "$1" -vcodec h264 -acodec mp2 "$2"
    ffmpeg -i "$1" -vcodec h264 -acodec mp2 "$2"
}

download-music() {
    yta $1 --embed-thumbnail --embed-metadata \
    --parse-metadata "title:%(title)s" \
    --parse-metadata "uploader:%(artist)s" \
    --parse-metadata "playlist_title:%(album)s" \
    --parse-metadata "playlist_index:%(track_number)s" \
    --output "%(artist)s - %(title)s.%(ext)s" "$2"
}

net_temp_on()
{
    nmcli networking on
    # Wait for 5 minutes (300 seconds)
    sleep 300
    # Disable internet
    nmcli networking off
}

# Bind
#===============================================================================

bind '"\x08":backward-kill-word'
bind 'set completion-ignore-case on'
bind "TAB:menu-complete"
bind "set show-all-if-ambiguous on"
bind "set menu-complete-display-prefix on"
bind '"\e[Z": menu-complete-backward'
bind "set colored-stats On"
bind 'set mark-symlinked-directories On'
bind 'set show-all-if-ambiguous On'
bind 'set show-all-if-unmodified On'
bind 'set visible-stats On'

shopt -s checkwinsize
shopt -s globstar

# Add Terminal Functions
#===============================================================================

if [ "$PWD" = "$HOME" ]; then
    cd "$(cat $XDG_CACHE_HOME/last-dir.txt)"
fi

if [ -x /usr/lib/command-not-found -o -x /usr/share/command-not-found/command-not-found ]; then
	function command_not_found_handle {
        if [ -x /usr/lib/command-not-found ]; then
		   /usr/lib/command-not-found -- "$1"
           return $?
        elif [ -x /usr/share/command-not-found/command-not-found ]; then
		   /usr/share/command-not-found/command-not-found -- "$1"
           return $?
		else
		   printf "%s: command not found\n" "$1" >&2
		   return 127
		fi
	}
fi

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
