New-Item -ItemType SymbolicLink -Path "$HOME\AppData\Local\nvim" -Target "$HOME\Dotfiles\nvim"
New-Item -ItemType SymbolicLink -Path "$HOME\AppData\Roaming\flameshot" -Target "$HOME\Dotfiles\Desktop\flameshot"
New-Item -ItemType SymbolicLink -Path "$HOME\.gitconfig" -Target "$HOME\Dotfiles\git\config"
New-Item -ItemType SymbolicLink -Path "$HOME\.bashrc" -Target "$HOME\Dotfiles\bash\windows.sh"
New-Item -ItemType SymbolicLink -Path "$HOME\.wezterm.lua" -Target "$HOME\Dotfiles\Desktop\wezterm.lua"
New-Item -ItemType SymbolicLink -Path "$HOME\AppData\Roaming\Voidstar\FilePilot\FPilot-Config.json" -Target "$HOME\Dotfiles\Desktop\Windows\FPilot-Config.json"
New-Item -ItemType SymbolicLink -Path "$HOME\AppData\Roaming\TaskSlinger\themes.json" -Target "$HOME\Dotfiles\Desktop\Windows\TaskSlinger\themes.json"
New-Item -ItemType SymbolicLink -Path "$HOME\AppData\Roaming\TaskSlinger\UserSettings.ini" -Target "$HOME\Dotfiles\Desktop\Windows\TaskSlinger\UserSettings.ini"

