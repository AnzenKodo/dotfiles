PROMPT_COMMAND=''
PS1='\n\[\e[38;2;251;73;52m\]\h\[\e[0m\]@\[\e[38;2;250;189;47m\]\u\[\e[0m\]:\[\e[38;2;125;174;163m\]\w\[\e[38;2;184;187;38m\]${PS1_CMD1}\n\[\e[0m\]\\$ '

PROMPT_COMMAND='PS1_CMD1=$(__git_ps1 " (%s)");history -a'

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_DOWNLOAD_DIR="$HOME/Downloads"
export XDG_DOCUMENTS_DIR="$HOME/Documents"
export XDG_MUSIC_DIR="$HOME/Music"
export XDG_PICTURES_DIR="$HOME/Pictures"
export XDG_VIDEOS_DIR="$HOME/Videos"
export USR_APPLICATIONS_DIR="$HOME/Applications"

export TERM="ghostty"
export EDITOR="zed"
export BROWSER="brave-browser --disable-features=OutdatedBuildDetector"
export FILE_MANAGER="thunar"
export PASSWORD_MANAGER="keepassxc"
export OFFICE="onlyoffice"

export DOTFILES="$HOME/Dotfiles"
export NOTES="$HOME/Online/Notes"

export PATH="$USR_APPLICATIONS_DIR/AppImages:$USR_APPLICATIONS_DIR/bin"\
":$USR_APPLICATIONS_DIR/ffmpeg:$USR_APPLICATIONS_DIR/jdk-23/bin"\
":~/Code/miniapps:~/Code/miniapps/bin"\
":$XDG_DATA_HOME/python/bin:$CARGO_HOME/bin:$PATH"

export HISTFILE=$XDG_STATE_HOME/bash/history
export HISTCONTROL=ignoreboth:erasedups:ignorespace
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "

# export LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libgtk3-nocsd.so.0"
unset LD_PRELOAD
export GTK2_RC_FILES=$DOTFILES/Desktop/gtk2rc
export ICEAUTHORITY=$XDG_CACHE_HOME/ICEauthority
# export XAUTHORITY=$XDG_RUNTIME_DIR/Xauthority
export ERRFILE="$XDG_CACHE_HOME/X11/xsession-errors"
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export CALCHISTFILE="$XDG_CACHE_HOME"/calc_history
export FCEUX_HOME="$XDG_CONFIG_HOME"/fceux
export ASPELL_CONF="personal $DOTFILES/Desktop/en.pws; repl $XDG_DATA_HOME/aspell.en.prepl"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export AW_SYNC_DIR="$HOME/Online/Dotfiles/ActivityWatch"
export WINEPREFIX="$XDG_DATA_HOME"/wineprefixes/default

export GOPATH="$XDG_DATA_HOME"/go
export GOMODCACHE="$XDG_CACHE_HOME"/go/mod
export CPATH=/usr/include/freetype2/:$CPATH
export PYTHON_HISTORY=$XDG_STATE_HOME/python/history
export PYTHONPYCACHEPREFIX=$XDG_CACHE_HOME/python
export PYTHONUSERBASE=$XDG_DATA_HOME/python
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup

source /etc/bash_completion
source ~/Applications/ghostty/zig-out/share/bash-completion/completions/ghostty.bash
eval "$(gtrash completion bash)"
eval "$(zoxide init bash)"
eval "$(fzf --bash)"
export FZF_DEFAULT_OPTS="
  --bind 'tab:down'
  --bind 'shift-tab:up'
"

_open_complete() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=( $(compgen -c "$cur") )
}


alias bat="bat --theme=gruvbox-dark --style=numbers"
alias btm="btm --color gruvbox"

alias ..="cd .."
alias ~="cd ~"
alias ls="ls -a --color=always --group-directories-first"
alias ln="ln -i"
alias mkdir="mkdir -vp"
alias mv="mv -vi"
alias cp="cp -vi"
alias dir="dir --color=always"
alias ln="ln -v"
alias cp="cp -r"
alias cat="bat --style=plain --pager=none"
alias grep="rg"
alias diff="bat --style=plain -d"
alias top="btm --battery --enable_cache_memory --enable_gpu_memory --network_use_bytes --network_use_binary_prefix --mem_as_value --show_table_scroll_position"
alias xclip="xclip -selection clipboard"
alias zip="zip -r"
alias tar="tar -v"
alias wget="wget --hsts-file=\"$XDG_CACHE_HOME/wget-hsts\""
alias rm="gtrash put"
alias rmr="gtrash restore"
alias rme="gtrash find --rm ."

alias refresh="source ~/.bashrc"

ask_and_run() {
    read -p "Do you want to proceed? (y/n): " ans
    case $ans in
        [Yy]* )
            eval "$@" ;;
        * )
            echo "Operation cancelled." ;;
    esac
}

alias poweroff="ask_and_run sudo poweroff"
alias reboot="ask_and_run sudo reboot"
alias suspend="sudo pm-suspend"
alias hibernate="sudo pm-hibernate"
alias quit="ask_and_run i3-msg exit"
alias lock="i3lock -n -f -c 32302F -i $DOTFILES/Images/'Lockscreen Wallpaper.png'"
o() {
    "$@" > /dev/null 2>&1 & disown
}
oe() {
    "$@" > /dev/null 2>&1 & disown
    exit
}
complete -F _open_complete o
complete -F _open_complete oe

alias micro="micro --config-dir $DOTFILES/Desktop/micro"
alias todo="micro $NOTES/Todo.md"
alias feed="micro $NOTES/Feed.md"
alias xcolor="xcolor | xclip"
alias yt="yt-dlp --ffmpeg-location $USR_APPLICATIONS_DIR/ffmpeg/ -S ext"
alias yta="yt-dlp --ffmpeg-location $USR_APPLICATIONS_DIR/ffmpeg/ --extract-audio --audio-format"
alias tldr="tldr -c"

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

backup() {
    opml_to_feed $HOME/Online/Dotfiles/podcast.opml $NOTES/Feed.md
    cp $XDG_DATA_HOME/activitywatch ~/Online/Dotfiles/
    # files=($XDG_DOWNLOAD_DIR/tampermonkey-backup-chrome*.txt)
    # if [ -f $file ]; then
    #     if [[ ${#files[@]} -gt 0 ]]; then
    #         mv "${files[0]}" $DOTFILES/tampermonkey.json
    #     fi
    #     rm $XDG_DOWNLOAD_DIR/tampermonkey-backup-chrome*.txt
    # fi

    cd $DOTFILES
    push "Backup from Desktop"
    cd -

    rclone bisync $HOME/Online Personal: \
        --config="$HOME/Online/Dotfiles/rclone.conf" \
        --exclude buffers/** --exclude sqlite.db --exclude Dotfiles/activitywatch/aw-client/** \
        --check-first --metadata --checksum --download-hash --verbose \
        --resync --resync-mode newer --conflict-resolve newer --copy-links \
        --compare 'size,modtime,checksum'

    sudo timeshift --create --verbose
}

backup-force() {
    rclone sync $HOME/Online Personal: \
        --config="$HOME/Online/Dotfiles/rclone.conf" \
}

project() {
    local proj_path=~/Code/Scuttle
    cd $proj_path

    o $EDITOR
    o vscodium
    o $BROWSER
}

dotfile_link() {
    ln -sf $DOTFILES/Desktop/$1 $XDG_CONFIG_HOME
}

compress-mp4() {
    echo ffmpeg -i "$1" -vcodec h264 -acodec mp2 "$2"
    ffmpeg -i "$1" -vcodec h264 -acodec mp2 "$2"
}

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
