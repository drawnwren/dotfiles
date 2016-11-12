#! /bin/bash

# install brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# install git
brew install git

# make backup dirs for vim
mkdir -p ~/.vim/tmp/undo//
mkdir ~/.vim/tmp/backupdir/
mkdir ~/.vim/tmp/swap/

# install dein
sh -c "$(curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh)" ~/.vim/dein/

# install iterm
brew cask install iterm2

# install bestmacs
brew cask install emacs

# install zsh and oh-my-zsh
brew install zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

brew install stow
brew install neovim/neovim/neovim

# symlink vimrc to ~/.config/nvim/init.vim
ln -s stow/vim/.vimrc ~/.config/nvim/init.vim

# install lein
curl https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein > ~/bin/lein
chmod a+x ~/bin/lein
lein

# install nvm and use it to install node
sh -c "$(curl https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh)"
nvm install node
nvm use node

