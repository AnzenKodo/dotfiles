pkg install openssh neovim git axel tokei 
pkg install bat

git clone https://github.com/AnzenKodo/dotfiles Dotfiles --depth=1

ln -sfv ~/Dotfiles/bash/android.sh $HOME/.bashrc
ln -sfv ~/Dotfiles/nvim $XDG_CONFIG_HOME
ln -srf ~/Dotfiles/git $XDG_CONFIG_HOME
ln -sfv ~/Dotfiles/fonts $XDG_DATA_HOME

mkdir .local .config Downloads Applications Applications/bin
