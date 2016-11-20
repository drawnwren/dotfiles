#! /bin/bash

unamestr=`uname`
platform='unknown'
pack='unknown'

if [[ "$unamestr" == 'Linux' ]]; then
  platform='linux'
  pack='sudo pacman -S'
  leinvar='/usr/bin/lein'
  sudo pacman -Sy
  $pack emacs, neovim
elif [[ "$unamestr" == 'Darwin' ]]; then
  platform='mac'
  # install brew
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

  # install iterm
  brew cask install iterm2, emacs
  leinvar='~/bin/lein'
  pack='brew install'

  $pack neovim/neovim/neovim
fi

# install git, stow, zsh
$pack git, stow, zsh

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

# unstow emacs dotfiles
stow emacs

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
rm ~/.zshrc
stow zsh


# symlink vimrc to ~/.config/nvim/init.vim
ln -s dotfiles/vim/.vimrc ~/.config/nvim/init.vim

# install lein
sudo curl https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein > $leinvar
chmod a+x $leinvar
lein

# install nvm and use it to install node
sh -c "$(curl https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh)"
export NVM_DIR="~/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
nvm install node
nvm use node

