# Load Default Profile
#===============================================================================

last_dir_state_path="$HOME/AppData/last-dir.txt"
bash_state_path=$HOME/AppData/bash
source ~/Dotfiles/bash/main.sh

export GIT_PS1_SHOWDIRTYSTATE=false

# Source Files
#===============================================================================

eval "$(trash completions bash)"

# Alias
#===============================================================================

alias rm="trash"

alias poweroff='ask_and_run cmd //c shutdown -s -f -t 0'
alias reboot='ask_and_run cmd //c shutdown -r -f -t 0'
alias logout='ask_and_run cmd //c shutdown -l'
alias suspend='ask_and_run rundll32.exe powrprof.dll,SetSuspendState 0,1,0'

# Functions
#===============================================================================

function backup {
    winget export --include-versions -o $HOME/Drive-Company/Dotfiles/winget.json
    git -C ~/Dotfiles add .
    git -C ~/Dotfiles commit -m "Backup from Windows Desktop"
    git -C ~/Dotfiles push
}

