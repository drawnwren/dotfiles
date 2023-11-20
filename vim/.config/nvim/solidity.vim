lua <<EOF
local opts = {
    on_attach = require("lsp_utils").on_attach,
    root_dir = require("lsp_utils").root_pattern(".git", "foundry.toml"),
  }
require'lspconfig'.solc.setup(opts)
EOF
