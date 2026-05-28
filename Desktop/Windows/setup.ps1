New-Item -ItemType SymbolicLink -Path "$HOME\AppData\Local\nvim" -Target "$HOME\Dotfiles\nvim"
New-Item -ItemType SymbolicLink -Path "$HOME\AppData\Roaming\flameshot" -Target "$HOME\Dotfiles\Desktop\flameshot"
New-Item -ItemType SymbolicLink -Path "$HOME\.gitconfig" -Target "$HOME\Dotfiles\git\config"

New-Item -ItemType SymbolicLink -Path "$HOME\Documents\WindowsPowerShell\" -Target "$HOME\Dotfiles\Desktop\Windows\WindowsPowerShell"
New-Item -ItemType SymbolicLink -Path "$HOME\.bashrc" -Target "$HOME\Dotfiles\bash\windows.sh"
New-Item -ItemType SymbolicLink -Path "$HOME\.wezterm.lua" -Target "$HOME\Dotfiles\Desktop\wezterm.lua"

# mkdir "$HOME\AppData\Roaming\alacritty"
# New-Item -ItemType SymbolicLink -Path "$HOME\AppData\Roaming\alacritty\alacritty.toml" -Target "$HOME\Dotfiles\Desktop\alacritty.toml"
