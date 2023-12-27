--all of my rust config stuff,
--it was getting confusing
-- Set updatetime for CursorHold
vim.opt.updatetime = 300

--show diagnostic popup on cursor hold
vim.api.nvim_create_autocmd('CursorHold', {
  pattern = '*',
  command = 'lua vim.diagnostic.open_float(nil, {focusable = false})'
})
Config = {}

function Config.config()
    -- rust-tools codelldb fancy debugger setup
    local extension_path = '/home/wing/.vscode/extensions/vadimcn.vscode-lldb-1.10.0/'
    local codelldb_path = extension_path .. 'adapter/codelldb'
    local liblldb_path = extension_path .. 'lldb/lib/liblldb.so'
    local this_os = vim.loop.os_uname().sysname

    local rust_tools_opts = {
        -- ... other configs, which I don't have rn
        tools = { -- rust-tools options
            -- Automatically set inlay hints (type hints)
            autoSetHints = true,

            -- Whether to show hover actions inside the hover window
            -- This overrides the default hover handler 
             -- hover_with_actions = true,

            -- how to execute terminal commands
            -- options right now: termopen / quickfix
            executor = require("rust-tools/executors").termopen,

            runnables = {
                -- whether to use telescope for selection menu or not
                use_telescope = true

                -- rest of the opts are forwarded to telescope
            },

            debuggables = {
                -- whether to use telescope for selection menu or not
                use_telescope = true

                -- rest of the opts are forwarded to telescope
            },

            -- These apply to the default RustSetInlayHints command
            inlay_hints = {

                -- Only show inlay hints for the current line
                only_current_line = false,

                -- Event which triggers a refresh of the inlay hints.
                -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
                -- not that this may cause  higher CPU usage.
                -- This option is only respected when only_current_line and
                -- autoSetHints both are true.
                only_current_line_autocmd = "CursorHold",

                -- wheter to show parameter hints with the inlay hints or not
                show_parameter_hints = true,

                -- prefix for parameter hints
                parameter_hints_prefix = "-> ",

                -- prefix for all the other hints (type, chaining)
                other_hints_prefix = "<= ",

            },

            hover_actions = {
                -- the border that is used for the hover window
                -- see vim.api.nvim_open_win()
                border = {
                    {"╭", "FloatBorder"}, {"─", "FloatBorder"},
                    {"╮", "FloatBorder"}, {"│", "FloatBorder"},
                    {"╯", "FloatBorder"}, {"─", "FloatBorder"},
                    {"╰", "FloatBorder"}, {"│", "FloatBorder"}
                },

                -- whether the hover action window gets automatically focused
                auto_focus = false
            },

            -- settings for showing the crate graph based on graphviz and the dot
            -- command
            crate_graph = {
                -- Backend used for displaying the graph
                -- see: https://graphviz.org/docs/outputs/
                -- default: x11
                backend = "x11",
                -- where to store the output, nil for no output stored (relative
                -- path from pwd)
                -- default: nil
                output = nil,
                -- true for all crates.io and external crates, false only the local
                -- crates
                -- default: true
                full = true,
            }
        },

        -- all the opts to send to nvim-lspconfig
        -- these override the defaults set by rust-tools.nvim
        -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
        server = {
          on_attach = require('lsp_utils').on_attach,
          settings = {
            ["rust-analyzer"] = {
                cargo = {
                        autoreload = true
                },
              checkOnSave = {
                command = "clippy"
              },
            }
          }
        }, -- rust-analyser options

        -- debugging stuff
        dap = {
                adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path)        
        },
    }

    require('rust-tools').setup(rust_tools_opts)
end

return Config
