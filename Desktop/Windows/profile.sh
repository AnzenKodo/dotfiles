# Load Global Profile
#===============================================================================

last_dir_path="$HOME/AppData/last-dir.txt"
source ~/Dotfiles/Desktop/profile.sh

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
}
