mkdir .local .config Downloads Applications Applications/bin

pkg install openssh neovim git axel tokei bash-completion

git clone https://github.com/AnzenKodo/dotfiles Dotfiles --depth=1

ln -sfv ~/Dotfiles/bash/android.sh $HOME/.bashrc
ln -sfv ~/Dotfiles/nvim $XDG_CONFIG_HOME
ln -srf ~/Dotfiles/git $XDG_CONFIG_HOME

termux-setup-storage

# Setup SSH 
# =============================================================================

ssh-keygen -t ed25519 -C "LocalSmokal"
eval $(ssh-agent -s)
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
