return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use 'mfussenegger/nvim-dap'
  use 'nvim-lualine/Lualine.nvim'
  -- rust tools and debugging plugins
  use 'simrat39/rust-tools.nvim'


  --common dependencies
  use 'nvim-lua/plenary.nvim'

  -- tree sitter
  use {
     'nvim-treesitter/nvim-treesitter',
     run = ':TSUpdate'
  }  

  --telescope
  use 'nvim-telescope/telescope.nvim'
  use 'nvim-telescope/telescope-ui-select.nvim'

  --lsp
  use 'neovim/nvim-lspconfig'

  -- cmp
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'

  --null-ls
  use 'jose-elias-alvarez/null-ls.nvim'

  use 'simrat39/rust-tools.nvim'
  use({
  "jackMort/ChatGPT.nvim",
    config = function()
      require("chatgpt").setup()
    end,
    requires = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    }
  })
end)
