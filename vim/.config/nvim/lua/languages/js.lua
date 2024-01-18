local opts = {
  on_attach = require("lsp_utils").on_attach
}

require'lspconfig'.tsserver.setup{opts}

