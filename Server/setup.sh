sudo apt install git bash-completion

mkdir $XDG_STATE_HOME/bash
ln -sfv ~/Dotfiles/bash/linux.sh   $HOME/.bashrc
ln -sf ~/Dotfiles/tmux             $XDG_CONFIG_HOME
ln -sf ~/Dotfiles/nvim             $XDG_CONFIG_HOME
ln -sfr ~/Dotfiles/git             $XDG_CONFIG_HOME
rm $HOME/.ssh
ln -sf ~/Drive/Dotfiles/ssh        $HOME/.ssh
