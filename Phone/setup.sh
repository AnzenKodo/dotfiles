pkg install openssh neovim git

git clone https://github.com/AnzenKodo/dotfiles Dotfiles --depth=1

ln -sfv ~/Dotfiles/bash/android.sh $HOME/.bashrc

mkdir $XDG_STATE_HOME/bash
touch $XDG_STATE_HOME/bash/history
