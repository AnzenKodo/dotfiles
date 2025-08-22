New-Item -ItemType SymbolicLink -Path "$HOME\AppData\Local\nvim" -Target "$HOME\Dotfiles\Desktop\nvim"
New-Item -ItemType SymbolicLink -Path "$HOME\Documents\WindowsPowerShell\" -Target "$HOME\Dotfiles\Desktop\Windows\WindowsPowerShell"
New-Item -ItemType SymbolicLink -Path "$HOME\.gitconfig" -Target "C:\Users\aman.v\Dotfiles\Desktop\git\config"
New-Item -ItemType SymbolicLink -Path "$HOME\.bashrc" -Target "C:\Users\aman.v\Dotfiles\Desktop\Windows\profile.sh"

mkdir "$HOME\AppData\Roaming\alacritty"
New-Item -ItemType SymbolicLink -Path "$HOME\AppData\Roaming\alacritty\alacritty.toml" -Target "C:\Users\aman.v\Dotfiles\Desktop\alacritty.toml"
