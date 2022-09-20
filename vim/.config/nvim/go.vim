
" format on write
autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync(nil, 200)

" pretty empty for now, but I have a feeling that I'll fill it up
lua <<EOF

local opts = {
  on_attach = require("lsp_utils").on_attach
  }

require'lspconfig'.gopls.setup(opts)

EOF
