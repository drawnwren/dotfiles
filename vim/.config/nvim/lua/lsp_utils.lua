-- module for my lsp common configurations. invidividual lsp config still
-- happens in each language.lua file

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local utils = {}
vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', {noremap=true, silent=true, desc="Open diagnostics"})
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', {noremap=true, silent=true, desc="Go to previous diagnostic"})
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', {noremap=true, silent=true, desc="Go to next diagnostic"})

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
function utils.on_attach(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  vim.cmd('autocmd BufWritePre <buffer> lua vim.lsp.buf.format(nil, {async = true})')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', {noremap=true, silent=true, desc="Go to declaration"})
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', {noremap=true, silent=true, desc="Go to definition"})
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', {noremap=true, silent=true, desc="Hover"})
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', {noremap=true, silent=true, desc="Go to implementation"})
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', {noremap=true, silent=true, desc="Signature help"})
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', {noremap=true, silent=true, desc="Add workspace folder"})
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', {noremap=true, silent=true, desc="Remove workspace folder"})
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', {noremap=true, silent=true, desc="List workspace folders"})
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', {noremap=true, silent=true, desc="Go to type definition"})
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', {noremap=true, silent=true, desc="Rename"})
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', {noremap=true, silent=true, desc="Code action"})
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', {noremap=true, silent=true, desc="Go to references"})
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.format()<CR>', {noremap=true, silent=true, desc="Format"})
end

return utils
