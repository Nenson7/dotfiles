-- Remaps
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", "<leader>h", ":nohlsearch<CR>", opts)
map("n", "<leader>e", ":Ex<CR>", opts)

map("n", "<A-j>", ":m .+1<CR>==", opts)
map("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)

map("n", "<A-k>", ":m .-2<CR>==", opts)
map("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)


map("i", "jk", "<Esc>", opts)
