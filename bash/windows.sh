# Load Default Profile
#===============================================================================

last_dir_state_path="$HOME/AppData/last-dir.txt"
bash_state_path=$HOME/AppData/bash
source ~/Dotfiles/bash/default.sh

# Alias
#===============================================================================

alias poweroff='ask_and_run shutdown /s /t 0'
alias reboot='ask_and_run shutdown /r /t 0'
alias logout='ask_and_run shutdown /l'
alias suspend='ask_and_run rundll32.exe powrprof.dll,SetSuspendState 0,1,0'
alias hibernate='ask_and_run shutdown /h'

# Functions
#===============================================================================

function rm() {
    if [ $# -eq 0 ]; then
        echo "Usage: rm <file or directory>..."
        return 1
    fi

    ps_command="Remove-ItemToRecycleBin"
    for arg in "$@"; do
        abs_unix_path=$(readlink -f "$arg")
        if [ -z "$abs_unix_path" ]; then
            echo "Error: Failed to resolve path for '$arg'"
            return 1
        fi
        win_path=$(cygpath -w "$abs_unix_path")
        ps_command="$ps_command '$win_path'"
    done

    powershell.exe -Command "$ps_command"
}

function backup {
    winget export --include-versions -o $HOME/Dotfiles/Desktop/Windows/winget.json
    cd ~/Dotfiles
    push "Backup from Windows Desktop"
    cd -

    rclone \
        bisync ~/Drive Personal: \
        --exclude buffers/** \
        --check-first --metadata --checksum --download-hash --verbose \
        --compare size,modtime,checksum
        --resync
}
