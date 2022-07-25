autocmd BufWritePre *.tsx lua vim.lsp.buf.formatting_sync(nil, 200)

lua <<EOF
local opts = {
  on_attach = require("lsp_utils").on_attach
  }

require'lspconfig'.tsserver.setup{opts}
EOF
