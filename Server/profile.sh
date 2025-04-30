# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# ========================================================================

HISTFILE=$XDG_STATE_HOME/bash/history
HISTCONTROL=ignoreboth:erasedups:ignorespace
HISTFILESIZE=
HISTSIZE=
HISTTIMEFORMAT="[%F %T] "

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

export DOTFILES="$HOME/Dotfiles"
export DRIVE="$HOME/Drive"
export NOTES="$DRIVE/Notes"

export EDITOR="micro"

export PATH="$USR_APPLICATIONS_DIR/AppImages:$USR_APPLICATIONS_DIR/bin"\
":$USR_APPLICATIONS_DIR/ffmpeg:$USR_APPLICATIONS_DIR/jdk-23/bin"\
":~/Code/miniapps:~/Code/miniapps/bin"\
":$XDG_DATA_HOME/python/bin:$CARGO_HOME/bin:$PATH"

export GOPATH="$XDG_DATA_HOME"/go
export GOMODCACHE="$XDG_CACHE_HOME"/go/mod
export CPATH=/usr/include/freetype2/:$CPATH
export PYTHON_HISTORY=$XDG_STATE_HOME/python/history
export PYTHONPYCACHEPREFIX=$XDG_CACHE_HOME/python
export PYTHONUSERBASE=$XDG_DATA_HOME/python
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export WGETRC="$XDG_CONFIG_HOME/wgetrc"

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
alias ls="ls -lha --color=always --group-directories-first"
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

alias micro="micro --config-dir $DOTFILES/Desktop/micro"
alias todo="o $EDITOR $DRIVE/Todo.md"
alias feed="$EDITOR $NOTES/Feed.md"
alias xcolor="xcolor | xclip"
alias yt="yt-dlp --ffmpeg-location $USR_APPLICATIONS_DIR/ffmpeg/ -S ext"
alias yta="yt-dlp --ffmpeg-location $USR_APPLICATIONS_DIR/ffmpeg/ --extract-audio --audio-format"
alias tldr="tldr -c"
alias rsync="rsync --hard-links --archive --recursive --update --executability \
    --verbose --human-readable --progress"
alias rsync_git="rsync --filter='dir-merge,- .gitignore' --delete"

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
