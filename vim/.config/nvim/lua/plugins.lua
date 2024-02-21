return require('lazy').setup({
   {
       'chipsenkbeil/distant.nvim', 
       branch = 'v0.3',
       config = function()
           require('distant'):setup()
       end
   },
   "catppuccin/nvim",
   "mfussenegger/nvim-dap",
   {
      "rcarriga/nvim-dap-ui",
      lazy = false,
      requires = {"mfussenegger/nvim-dap"},
   },
   "thehamsta/nvim-dap-virtual-text",
   'nvim-lualine/Lualine.nvim',
   {
       -- Which-key Extension
       "folke/which-key.nvim",
       lazy = true,
   },


  -- rust tools and debugging plugins
   {
    'simrat39/rust-tools.nvim',
      config = require('languages/rust').config,
   },


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
       "nvim-telescope/telescope-file-browser.nvim",
       dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
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
   'nvimtools/none-ls.nvim',
  'tpope/vim-fugitive',
  'samoshkin/vim-mergetool',
  -- indentation
  'tpope/vim-sleuth',
  'github/copilot.vim',
  'terryma/vim-expand-region',
  'tpope/vim-surround',
   "williamboman/mason.nvim",
   "williamboman/mason-lspconfig.nvim",
   "neovim/nvim-lspconfig",
   --'IndianBoy42/tree-sitter-just'
})
