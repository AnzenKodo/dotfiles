pkg install root-repo
pkg install x11-repo
pkg install git

git config --global user.email "AnzenKodo@users.noreply.github.com"
git config --global user.name "AnzenKodo"
git config --global credential.helper store

git clone https://github.com/AnzenKodo/dotfiles

ln -sf $HOME/dotfiles/backup.sh $HOME/.shortcuts/Backup
