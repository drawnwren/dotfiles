set nocompatible
" Add the dein installation directory into runtimepath
set runtimepath+=/Users/wren/.cache/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.cache/dein')
 call dein#begin('~/.cache/dein')

 call dein#add('~/.cache/dein')
 call dein#add('Shougo/deoplete.nvim')
 call dein#add('flazz/vim-colorschemes')
 call dein#add('scrooloose/nerdtree')
 call dein#add('ryanoasis/vim-devicons')
 call dein#add('neomake/neomake')
 call dein#add('jpalardy/vim-slime')
 call dein#add('pangloss/vim-javascript')
 call dein#add('vim-airline/vim-airline')
 call dein#add('terryma/vim-expand-region')
 call dein#add('airblade/vim-gitgutter')
 call dein#add('ctrlpvim/ctrlp.vim')
 call dein#add('tomlion/vim-solidity')
 call dein#add('vim-airline/vim-airline-themes')
 call dein#add('Valloric/YouCompleteMe')
 call dein#add('vim-syntastic/syntastic')

if !has('nvim')
   call dein#add('roxma/nvim-yarp')
   call dein#add('roxma/vim-hug-neovim-rpc')
 endif

 call dein#end()
 call dein#save_state()
endif

filetype plugin indent on
syntax enable

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:neomake_javascript_enabled_makers = ['eslint']
autocmd InsertLeave,TextChanged * update | Neomake

let g:syntastic_error_symbol = '❌'
let g:syntastic_style_error_symbol = '⁉️'
let g:syntastic_warning_symbol = '⚠️'
let g:syntastic_style_warning_symbol = '💩'

highlight link SyntasticErrorSign SignColumn
highlight link SyntasticWarningSign SignColumn
highlight link SyntasticStyleErrorSign SignColumn
highlight link SyntasticStyleWarningSign SignColumn

set undodir=~/.vim/tmp/undo//
set backupdir=~/.vim/tmp/backupdir//
set directory=~/.vim/tmp/swap//
set noswapfile
set nocompatible
set clipboard=unnamedplus

colorscheme Tomorrow-Night
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
set relativenumber
set undofile

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

inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>


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
