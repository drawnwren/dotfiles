" format on write
lua <<EOF
local nvim_lsp = require("lspconfig")

-- pretty empty rn
--settings = {
-- old pylsp settings
--      pylsp = {
--        formatcommand = {"black"},
--        plugins = {
--          pylint = { enabled = true, executable = "pylint" },
--          pyflakes = { enabled = false },
--          pycodestyle = { enabled = false },
--          jedi_completion = { fuzzy = true },
--          pyls_isort = { enabled = true },
--          pylsp_mypy = { enabled = true },
--        },
--      },
--    },
--
local opts = {
    on_attach = require("lsp_utils").on_attach,
    settings = { 
      pyright = { 
        analysis = { 
          useLibraryCodeForTypes = true, 
          linting = {pylintEnabled = false}
        }
      }
    },
    flags = {
      debounce_text_changes = 200,
    },
  }
nvim_lsp.pyright.setup(opts)

local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.black,
    },
})
EOF




