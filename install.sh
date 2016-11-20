#! /bin/bash

# install brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# install git
brew install git
git config --global user.name "Wren"
git config --global user.email "drawnwren@gmail.com"

# install stow
brew install stow

# make backup dirs for vim
mkdir -p ~/.vim/tmp/undo//
mkdir ~/.vim/tmp/backupdir/
mkdir ~/.vim/tmp/swap/
stow vim

# install dein
sh -c "$(curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh)" ~/.vim/dein/

# install iterm
brew cask install iterm2

# install bestmacs
brew cask install emacs
stow emacs

# install zsh and oh-my-zsh
brew install zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
stow zsh

brew install neovim/neovim/neovim

# symlink vimrc to ~/.config/nvim/init.vim
ln -s stow/vim/.vimrc ~/.config/nvim/init.vim

# install lein
curl https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein > ~/bin/lein
chmod a+x ~/bin/lein
lein

# install nvm and use it to install node
sh -c "$(curl https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh)"
export NVM_DIR="/Users/drew/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
nvm install node
nvm use node

