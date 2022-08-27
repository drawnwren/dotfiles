set nocompatible
set lazyredraw

"install plug if it hasn't been
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

"like NERDTree but CHADdier
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
Plug 'ryanoasis/vim-devicons'

Plug 'neomake/neomake'
Plug 'jpalardy/vim-slime'

" hard
Plug 'dusans/vim-hardmode'

Plug 'tpope/vim-surround'

" indentation
Plug 'tpope/vim-sleuth'
" git
Plug 'tpope/vim-fugitive'

if has('nvim')
  "Lualine
  Plug 'nvim-lualine/Lualine.nvim'
  " rust tools and debugging plugins
  Plug 'simrat39/rust-tools.nvim'

  "debugging
  Plug 'mfussenegger/nvim-dap'
  "common dependencies
  Plug 'nvim-lua/plenary.nvim'

  "lsp
  Plug 'neovim/nvim-lspconfig'

  " cmp
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-nvim-lsp'

endif

Plug 'terryma/vim-expand-region'
Plug 'ctrlpvim/ctrlp.vim'

"---------- Language Plugins ----------"
"Solidity highlighting
Plug 'TovarishFin/vim-solidity'
"JS highlighting
Plug 'pangloss/vim-javascript'
"justfile highlighting
Plug 'vmchale/just-vim'
" for making table in Markdown files
Plug 'dhruvasagar/vim-table-mode'

"snippets
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

Plug 'jiangmiao/auto-pairs'


"most important plugin(s?) aka themes
Plug 'folke/tokyonight.nvim', {'branch': 'main'}

Plug 'ryanoasis/vim-devicons'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-vsnip'

"NeoFormat
Plug 'sbdchd/neoformat'

"fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim' 

"tree sitter
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' } 

"telescope
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-ui-select.nvim'
call plug#end()

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif
filetype plugin indent on
syntax enable

" popup for just one match, do not insert until a selection is made,
" and force user to select, do not force
set completeopt=menuone,noinsert,noselect

"avoid showing extra messages when using completion
set shortmess+=c

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
set signcolumn=number
set numberwidth=3
set undofile

let g:tokyonight_style = "storm"
colorscheme tokyonight

let mapleader = "\<Space>"
nnoremap <Leader>o :CtrlP<CR>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>
nnoremap <Leader>a :Ack
nnoremap <Leader>n :CHADopen<CR>
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
let g:neoformat_enabled_python = ['black', 'yapf']
set formatoptions=jcroql
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

nnoremap H 0
nnoremap L $
nnoremap J G
nnoremap K gg

" make shift-tab de-indent
" for command mode
nnoremap <S-Tab> <<
" for insert mode
inoremap <S-Tab> <C-d>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

:set guioptions-=m
:set guioptions-=T
:set guioptions-=L
:set guioptions-=r


