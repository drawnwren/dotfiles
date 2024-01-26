local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- using my old vimrc for now, but I should probably just move it all to
-- init.vim
--source ~/.vimrc
-- source an init lua file separately because I don't like init.lua's error
-- behavior
require("plugins")

vim.keymap.set("n", " ", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "
vim.keymap.set("n", "<Leader>w", ":w<CR>", { silent = true, remap = true })
vim.keymap.set("n", "<Leader>q", ":q<CR>", { silent = true, remap = true })
vim.keymap.set("n", "<Leader>n", ":CHADopen<CR>", { silent = true, remap = true, desc = "Open CHADTree" })
vim.keymap.set("n", "<Leader>l", "<C-w>v<C-w>l", { silent = true, remap = true, desc = "Split right" })
vim.keymap.set("n", "<Leader>h", "<C-w>s<C-w>j", { silent = true, remap = true, desc = "Split below" })
vim.keymap.set("n", "<Leader>x", ":noh<CR>", { silent = true, remap = true, desc = "Clear highlights" })
vim.keymap.set("v", "v", "<Plug>(expand_region_expand)", { silent = true, remap = true, desc = "Expand region" })
vim.keymap.set("v", "<C-v>", "<Plug>(expand_region_shrink)", { silent = true, remap = true, desc = "Shrink region" })
vim.keymap.set("n", "<Leader><Leader>", "V", { silent = true, remap = true, desc = "Select line" })
vim.keymap.set("n", "<Leader>mt", "<plug>(MergetoolToggle)", { silent = true, remap = true, desc = "Toggle mergetool" })
vim.keymap.set("n", "<Leader>mr", ":MergetoolToggleLayout mr", { silent = true, remap = true, desc = "Toggle mergetool" })




-- vim.opt.mergetool_layout = 'mr'
-- vim.opt.mergetool_prefer_revision = 'local'
vim.opt.lazyredraw = true
vim.opt.ttyfast = true
vim.opt.visualbell = true
vim.opt.laststatus = 2
vim.opt.encoding = "utf-8"
vim.opt.scrolloff = 3
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
-- test
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smarttab = true
vim.opt.showmode = true
vim.opt.showcmd = true
vim.opt.hidden = true
vim.opt.swapfile = false

vim.opt.ruler = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "number"


vim.opt.nu = true
vim.opt.rnu = true


vim.opt.numberwidth = 3
vim.opt.undofile = true
-- yes, textwidth is a number and colorcolumn is a string. idk why
vim.opt.textwidth = 79
vim.opt.colorcolumn = "80"
vim.opt.formatoptions = "jcroql"



vim.opt.backupdir = vim.fn.stdpath("data") .. "/backup"
vim.opt.directory = vim.fn.stdpath("data") .. "/swap"
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"
vim.opt.clipboard = "unnamedplus"


local ok, _ = pcall(vim.cmd, 'colorscheme catppuccin-macchiato')
if not ok then
  vim.cmd 'colorscheme default' -- if the above fails, then use default
end


-- save either by switching buffers or by losing focus
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, { callback = function() if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then vim.api.nvim_command('silent update') end end, })


require("mason").setup()
require("mason-lspconfig").setup()

require("wing")
require("lsp_utils")
-- treesitter semantic highlight mappings
require("highlight")


require("wren-dap")

require("whichkey")

-- language specific changes
require("languages/rust")
require("languages/js")
require("languages/python")
require("languages/go")
require("languages/terraform")
