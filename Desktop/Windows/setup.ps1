New-Item -ItemType SymbolicLink -Path "$HOME\AppData\Local\nvim" -Target "$HOME\Dotfiles\nvim"
New-Item -ItemType SymbolicLink -Path "$HOME\.gitconfig" -Target "C:\Users\aman.v\Dotfiles\git\config"

New-Item -ItemType SymbolicLink -Path "$HOME\Documents\WindowsPowerShell\" -Target "$HOME\Dotfiles\Desktop\Windows\WindowsPowerShell"
New-Item -ItemType SymbolicLink -Path "$HOME\.bashrc" -Target "C:\Users\aman.v\Dotfiles\Desktop\Windows\profile.sh"
New-Item -ItemType SymbolicLink -Path "$HOME\.wezterm.lua" -Target "C:\Users\aman.v\Dotfiles\Desktop\wezterm.lua"
New-Item -ItemType SymbolicLink -Path 'C:\Users\aman.v\Drive\' -Target 'C:\Users\aman.v\My Drive\Drive"

# mkdir "$HOME\AppData\Roaming\alacritty"
# New-Item -ItemType SymbolicLink -Path "$HOME\AppData\Roaming\alacritty\alacritty.toml" -Target "C:\Users\aman.v\Dotfiles\Desktop\alacritty.toml"
