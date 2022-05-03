set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vimrc
" source an init lua file separately because I don't like init.lua's error
" behavior
source ~/.config/nvim/wing.lua
source ~/.config/nvim/rust.vim


