-- Remaps
local map = vim.keymap.set
local opts = { noremap = true, silent = true }
vim.g.mapleader = " "

-- map("n", "<leader>e", "<cmd>Ex<CR>", opts)

map("n", "<leader>h", ":nohlsearch<CR>", opts)

map("n", "<A-j>", ":m .+1<CR>==", opts)
map("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)

map("n", "<A-k>", ":m .-2<CR>==", opts)
map("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)

map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

-- Visual mode: indent and stay in visual selection
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Normal mode: indent current line
map("n", "<leader><", "<<", opts)
map("n", "<leader>>", ">>", opts)
