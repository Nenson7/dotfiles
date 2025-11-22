-- Options
local o = vim.opt

o.number = true
o.relativenumber = true

o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.smartindent = true

o.ignorecase = true
o.smartcase = true
o.hlsearch = true
o.incsearch = true

o.termguicolors = true
o.scrolloff = 8
o.mouse = ""

o.clipboard = "unnamedplus"

o.undodir = os.getenv("HOME") .. "/.vim/undodir"
o.undofile = true
o.swapfile = false
o.backup = false

o.updatetime = 50
-- o.signcolumn = "yes"

o.wrap = false
vim.g.mapleader = " "
