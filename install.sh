#! /bin/bash
# TODO: still need to add font support and i3 for Arch

unamestr=`uname`
platform='unknown'
pack='unknown'
packages='git, stow, zsh'

if [[ "$unamestr" == 'Linux' ]]; then
  platform='linux'
  pack='sudo pacman -S'
  leinvar='/usr/bin/'
  sudo pacman -Sy

  # install listed packages
  $pack $packages, emacs, neovim, build-essential, cmake, python-dev, python3-dev

  # install yaourt
  git clone https://aur.archlinux.org/package-query.git
  cd package-query && makepkg -si && cd ..
  git clone https://aur.archlinux.org/yaourt.git
  cd yaourt && makepkg -si && cd ..
elif [[ "$unamestr" == 'Darwin' ]]; then
  platform='mac'
  # install brew
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

  # install iterm
  brew cask install iterm2, emacs
  leinvar='~/bin/'
  pack='brew install'

  $pack $packages, neovim/neovim/neovim
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

# unstow emacs dotfiles
stow emacs

# install oh-my-zsh
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
sh -c "$(curl https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh)"
export NVM_DIR="~/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
nvm install node
nvm use node

