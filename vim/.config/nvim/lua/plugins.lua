return require('lazy').setup({
   { "catppuccin/nvim", as = "catppuccin" },
   'mfussenegger/nvim-dap',
   'nvim-lualine/Lualine.nvim',
  -- rust tools and debugging plugins
   'simrat39/rust-tools.nvim',


  --common dependencies
   'nvim-lua/plenary.nvim',

  -- tree sitter
  {
     'nvim-treesitter/nvim-treesitter',
      lazy = false,
      version = nil, 
      build = ':TSUpdate'
  },  
  {
   'ms-jpq/chadtree', 
   branch = 'chad', 
   build = 'python3 -m chadtree deps'
  },
  --telescope
   'nvim-telescope/telescope.nvim',
   'nvim-telescope/telescope-ui-select.nvim',

  --lsp
  'neovim/nvim-lspconfig',

  -- cmp
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp',

  --null-ls
  'jose-elias-alvarez/null-ls.nvim',
  'tpope/vim-fugitive',
  -- indentation
  'tpope/vim-sleuth',
  'github/copilot.vim',
  'terryma/vim-expand-region',
})
