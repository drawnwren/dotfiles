set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
" using my old vimrc for now, but I should probably just move it all to
" init.vim
source ~/.vimrc
" source an init lua file separately because I don't like init.lua's error
" behavior
source ~/.config/nvim/wing.lua
source ~/.config/nvim/lua/lsp_utils.lua
source ~/.config/nvim/rust.vim
source ~/.config/nvim/python.vim





