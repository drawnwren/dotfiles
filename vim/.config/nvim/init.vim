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
source ~/.config/nvim/js.vim
source ~/.config/nvim/go.vim
source ~/.config/nvim/terraform.vim
"idk solc is broken rn source ~/.config/nvim/solidity.vim
augroup packer_user_config
  autocmd!
  autocmd BufWritePost ~/.config/nvim/lua/plugins.lua source <afile> | PackerCompile
augroup end
source ~/.config/nvim/lua/plugins.lua






