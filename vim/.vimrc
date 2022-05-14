set nocompatible
set lazyredraw
" Add the dein installation directory into runtimepath
set runtimepath+=/home/wing/.cache/dein/repos/github.com/Shougo/dein.vim


if dein#min#load_state('~/.cache/dein')
 call dein#begin('~/.cache/dein')
 call dein#add('/home/wing/.cache/dein/repos/github.com/Shougo/dein.vim')

 call dein#add('scrooloose/nerdtree')
 call dein#add('ryanoasis/vim-devicons')
 call dein#add('neomake/neomake')
 call dein#add('jpalardy/vim-slime')

 "Airline + themes
 call dein#add('vim-airline/vim-airline')
 call dein#add('vim-airline/vim-airline-themes')

 call dein#add('terryma/vim-expand-region')
 call dein#add('airblade/vim-gitgutter')
 call dein#add('ctrlpvim/ctrlp.vim')

 "Solidity highlighting
 call dein#add('tomlion/vim-solidity')
 "JS highlighting
 call dein#add('pangloss/vim-javascript')
 "justfile highlighting
 call dein#add('vmchale/just-vim')
 "snippets
 call dein#add('hrsh7th/vim-vsnip')

 call dein#add('hrsh7th/vim-vsnip-integ')

 call dein#add('jiangmiao/auto-pairs')

 " for making table in Markdown files
 call dein#add('dhruvasagar/vim-table-mode')

 "rainbow
 call dein#add('luochen1990/rainbow')

 " vim specific plugins
 if !has('nvim')
   call dein#add('roxma/nvim-yarp')
   call dein#add('roxma/vim-hug-neovim-rpc')
 " nvim specific plugins
 else 
  "most important plugin
  call dein#add("RRethy/nvim-base16")
  "common dependencies
  call dein#add('nvim-lua/plenary.nvim')
  "lsp
  call dein#add('neovim/nvim-lspconfig')

  " cmp
  call dein#add('hrsh7th/nvim-cmp')
  call dein#add('hrsh7th/cmp-nvim-lsp')
  call dein#add('hrsh7th/cmp-buffer')
  call dein#add('hrsh7th/cmp-path')
  call dein#add('hrsh7th/cmp-cmdline')
  call dein#add('hrsh7th/cmp-vsnip')

  " popup for just one match, do not insert until a selection is made, 
  " and force user to select, do not force
  set completeopt=menuone,noinsert,noselect

  "avoid showing extra messages when using completion
  set shortmess+=c
  
  " rust tools and debugging plugins
  call dein#add('simrat39/rust-tools.nvim')
  call dein#add('mfussenegger/nvim-dap')

  "tree sitter
  call dein#add('nvim-treesitter/nvim-treesitter', {'hook_post_update': 'TSUpdate'})

  "debugging 
  call dein#add('mfussenegger/nvim-dap')

  "telescope
  call dein#add('nvim-telescope/telescope.nvim')
  call dein#add('nvim-telescope/telescope-ui-select.nvim')
 endif

 call dein#end()
 call dein#save_state()
endif

filetype plugin indent on
syntax enable

let g:neomake_javascript_enabled_makers = ['eslint']
autocmd InsertLeave,TextChanged * update | Neomake

set undodir=~/.vim/tmp/undo
set backupdir=~/.vim/tmp/backup
set directory=~/.vim/tmp/swap
set noswapfile
set nocompatible
set clipboard=unnamedplus


set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

set encoding=utf-8
set scrolloff=3
set autoindent
set showmode
set showcmd
set hidden

set wildmenu
set wildmode=list:longest

set visualbell
set cursorline
set ttyfast
set ruler
set laststatus=2

" hybrid line number
set number relativenumber
set nu rnu
set undofile

"colors
let g:rainbow_active=1
colorscheme base16-tomorrow-night


let mapleader = "\<Space>"
nnoremap <Leader>o :CtrlP<CR>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>
nnoremap <Leader>a :Ack
nnoremap <Leader>n :NERDTree<CR>
nnoremap <Leader>l <C-w>v<C-w>l
nnoremap <Leader>s <C-w>s<C-w>j
nnoremap <Leader>x :noh<CR>
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)
nmap <Leader><Leader> V

noremap / /\v
vnoremap / /\v
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch
nnoremap <tab> %
vnoremap <tab> %

set wrap
set textwidth=79
set formatoptions=qrn1
set colorcolumn=85

nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>

inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

nnoremap j gj
nnoremap k gk

inoremap jk <ESC>

noremap gV `[v`]

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

:set guioptions-=m
:set guioptions-=T
:set guioptions-=L
:set guioptions-=r
