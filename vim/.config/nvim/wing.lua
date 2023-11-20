

-- telescope config
local ts_opts = {
  extensions = {
    ['ui-select'] = {
      require("telescope.themes").get_dropdown {  }
    }
  }
}
require("telescope").setup(ts_opts)

-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require("telescope").load_extension("ui-select")

require('lualine').setup {
  options = {
    theme = 'tokyonight'
  }
}

-- nvim-cmp config
-- Setup nvim-cmp.
local cmp = require('cmp')

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) 
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    -- Set `select` to `false` to only confirm explicitly selected items.
    ['<CR>'] = cmp.mapping.confirm({ 
      behavior = cmp.ConfirmBehavior.Insert,
      select = true 
    }),
  },

  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, 
    { name = 'buffer' },
    { name = 'path' }
  })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Tree Sitter!!
require('nvim-treesitter.configs').setup {
  ensure_installed = "all", -- one of "all", or a list of languages
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
  highlight = {
    enable = true,              -- false will disable the whole extension
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true
  },
  incremental_selection = {
    enable = true
  }
}

require('leetbuddy').setup({
    domain = "com",  -- `cn` for chinese leetcode
    language = "rs",
})
