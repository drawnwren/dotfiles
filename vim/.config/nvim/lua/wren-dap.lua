-- nvim-dap config
vim.api.nvim_set_keymap('n', '<leader>dt', ':lua require"dapui".toggle()<cr>', { noremap = true, silent = true , desc="Toggle DAP UI"})
vim.api.nvim_set_keymap('n', '<leader>db', ':lua require"dap".toggle_breakpoint()<cr>', { noremap = true, silent = true, desc="Toggle breakpoint" })
vim.api.nvim_set_keymap('n', '<leader>dB', ':lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dc', ':lua require"dap".continue()<cr>', { noremap = true, silent = true, desc="Continue" })
vim.api.nvim_set_keymap('n', '<leader>ds', ':lua require"dap".step_into()<cr>', { noremap = true, silent = true, desc="Step into" })
vim.api.nvim_set_keymap('n', '<leader>dn', ':lua require"dap".step_over()<cr>', { noremap = true, silent = true, desc="Step over" })
vim.api.nvim_set_keymap('n', '<leader>do', ':lua require"dap".step_out()<cr>', { noremap = true, silent = true, desc="Step out" })
vim.api.nvim_set_keymap('n', '<leader>dr', ':lua require"dap".restart()<cr>', { noremap = true, silent = true, desc="Restart" })
vim.api.nvim_set_keymap('n', '<leader>dl', ':lua require"dap".repl.open()<cr>', { noremap = true, silent = true, desc="Open REPL" })

require('dapui').setup({
  icons = {
    expanded = "▾",
    collapsed = "▸"
  },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = {"<CR>", "<2-LeftMouse>"},
    open = "o",
    remove = "d",
    edit = "e",
   repl = "r",
  },
  sidebar = {
    open_on_start = true,
    elements = {
      "scopes",
      "breakpoints",
      "stacks",
      "watches"
    },
    width = 40,
    position = "left" -- Can be "left" or "right"
  },
  tray = {
    open_on_start = true,
    elements = {
      "repl"
    },
    height = 10,
    position = "bottom" -- Can be "bottom" or "top"
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil   -- Floats will be treated as percentage of your screen.
  }
})

require("nvim-dap-virtual-text")
