# Shell Variables
#===============================================================================

# Prompt =======================================================================

PS1='\n\[\e[38;2;251;73;52m\]\h\[\e[0m\]@\[\e[38;2;250;189;47m\]\u\[\e[0m\]:\[\e[38;2;125;174;163m\]\w\[\e[38;2;184;187;38m\]${PS1_CMD1}\n\[\e[0m\]\\$ '
PROMPT_COMMAND='PS1_CMD1=$(__git_ps1 " (%s)");history -a'

# History ======================================================================

HISTCONTROL=ignoreboth:erasedups:ignorespace
HISTFILESIZE=
HISTSIZE=
HISTTIMEFORMAT="[%F %T] "

# Custom Application Variables =================================================

export TERMINAL="ghostty"
export EDITOR="nvim"
export BROWSER="brave --disable-features=OutdatedBuildDetector"
export FILES="thunar"
export OFFICE="onlyoffice"
export PASSWORD_MANAGER="keepassxc"

# Source Files
#===============================================================================

eval "$(zoxide init bash)"
eval "$(fzf --bash)"
export FZF_DEFAULT_OPTS="
  --bind 'tab:down'
  --bind 'shift-tab:up'
"

# Alias
#===============================================================================

alias bat="bat --theme=gruvbox-dark --style=numbers"

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

alias refresh="source ~/.bashrc"
alias dir_size="du -sh -- * | sort -hr"
alias timg="timg -p kitty --title='%b (%wx%h)'"
alias axel="axel --verbose"
alias yt="yt-dlp --ffmpeg-location ~/Applications/ffmpeg/ -S ext"
alias yta="yt-dlp --ffmpeg-location ~/Applications/ffmpeg/ --extract-audio --audio-format"
alias tldr="tldr -c"

alias todo="$EDITOR ~/Drive/Notes/Online/Todo.md"
alias feed="$EDITOR ~/Drive/Notes/Feed.md"

# Functions
#===============================================================================

cd()
{
    z "$@"
    pwd > $last_dir_path

}

help() {
    "$@" --help 2>&1 | bat --plain --language=help
}

len()
{
    str=$@
    echo ${#str}
}

push()
{
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

compress-mp4()
{
    echo ffmpeg -i "$1" -vcodec h264 -acodec mp2 "$2"
    ffmpeg -i "$1" -vcodec h264 -acodec mp2 "$2"
}

download-music()
{
    yta $1 --embed-thumbnail --embed-metadata \
    --parse-metadata "title:%(title)s" \
    --parse-metadata "uploader:%(artist)s" \
    --parse-metadata "playlist_title:%(album)s" \
    --parse-metadata "playlist_index:%(track_number)s" \
    --output "%(artist)s - %(title)s.%(ext)s" "$2"
}
setup_git_id()
{
    git config --local user.email "50282743+AnzenKodo@users.noreply.github.com"
    git config --local user.name "AnzenKodo"
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
