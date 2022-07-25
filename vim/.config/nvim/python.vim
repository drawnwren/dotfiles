" format on write
autocmd BufWritePre *.py lua vim.lsp.buf.formatting_sync(nil, 200)

lua <<EOF
-- pretty empty rn
--
local opts = {
    on_attach = require("lsp_utils").on_attach,
    settings = {
      pylsp = {
        formatcommand = {"black"},
        plugins = {
          pylint = { enabled = true, executable = "pylint" },
          pyflakes = { enabled = false },
          pycodestyle = { enabled = false },
          jedi_completion = { fuzzy = true },
          pyls_isort = { enabled = true },
          pylsp_mypy = { enabled = true },
        },
      },
    },
    flags = {
      debounce_text_changes = 200,
    },
  }
require("lspconfig").pylsp.setup(opts)
EOF
