#! /bin/bash

platform='unknown'
pack='unknown'
packages='git, stow, zsh, emacs, python-dev, python3-dev, clojure'

pack='sudo yum install'
leinvar='/usr/bin/'

# install listed packages
$pack $packages cmake

# install neovim
sudo dnf -y copr enable dperson/neovim
sudo dnf -y install neovim python3-neovim python3-neovim-gui

# install Hasklig
if [ ! d ~/hasklig ]
then
	mkdir ~/hasklig
	cd ~/hasklig
	wget https://github.com/i-tu/Hasklig/releases/download/1.1/Hasklig-1.1.zip
	unzip ~/hasklig/Hasklig-1.1.zip
	sudo cp *.otf /usr/share/fonts
	fc-cache
fi

# config git
git config --global user.name "Wren"
git config --global user.email "drawnwren@gmail.com"

# make backup dirs for vim
mkdir -p ~/.vim/tmp/undo//
mkdir ~/.vim/tmp/backupdir/
mkdir ~/.vim/tmp/swap/
stow vim

# install dein
mkdir -p ~/.vim/dein/
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > deininstall.sh
sh deininstall.sh ~/.vim/dein/

# install spacemacs

# unstow emacs dotfiles
stow emacs

# install oh-my-zsh
# FIXME: check to see if oh my zsh is already installed
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
rm ~/.zshrc
stow zsh

# symlink vimrc to ~/.config/nvim/init.vim
ln -s dotfiles/vim/.vimrc ~/.config/nvim/init.vim

# install lein
curl https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein > lein
sudo mv lein > $leinvar
sudo chmod a+x $leinvar/lein
lein

# install nvm and use it to install node
# FIXME: check for node and install if it doesn't exist
sh -c "$(curl https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh)"
export NVM_DIR="~/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
nvm install node
nvm use node

