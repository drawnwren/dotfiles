return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use "Dhanus3133/Leetbuddy.nvim"
  use 'mfussenegger/nvim-dap'
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
