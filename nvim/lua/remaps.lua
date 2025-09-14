-- Remaps
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

map("n", "<leader>h", ":nohlsearch<CR>", opts)
map("n", "<leader>e", ":Ex<CR>", opts)
