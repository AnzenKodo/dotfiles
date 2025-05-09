Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

$online_dir = "$HOME\Online"
$dotfiles = "$online_dir\Dotfiles"

del alias:rm -Force
Set-Alias -Name rm -Value Remove-ItemSafely
# del alias:curl -Force
# Set-Alias -Name curl -Value curl.exe

function wget {
	curl.exe -OJL $args
}

function unzip {
	Expand-Archive -Path $args[0] -DestinationPath $args[1]
}

function prompt {
    Write-Host ($((pwd).path)) -ForegroundColor Red
    return "> "
}

function project {
    cd 'C:\Users\DELL\Code\Swap Cards\'
}

function mklink($link, $target) {
    New-Item -Path $link -ItemType SymbolicLink -Value $target
}

function Notes {
	cd $online_dir\Notes
}

function todo  {
	focus "$online_dir/Notes/Todo.md"
}

function push($message) {
    git add .
    git commit -m $message
    git pull
    git push
}

function obackup {
	rclone.exe bisync $HOME\Online Personal: --config="$dotfiles\rclone.conf" -v -P --localtime --check-first -c -M --resync --exclude-if-present=log.txt --exclude=*.exe
}

function backup {
    $path = (pwd).path
    cd $dotfiles
    winget export install.json
    push "Updated dotfiles files"
    obackup
    cd $path
}

function link_all {
	mklink "$HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" $dotfiles/profile.ps1
	mklink "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" $dotfiles/profile.ps1
	mklink "$HOME\AppData\Roaming\alacritty/alacritty.toml" $dotfiles/alacritty.toml
	mklink "$HOME\.gitconfig" $dotfiles\git.init
}

function ff {
	If (Test-Path -Path .git) {
		git grep -n --untracked $args
	} else {
		git grep -n --no-index $args
	}
}