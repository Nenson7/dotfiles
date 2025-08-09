-- ==========================================
-- NEOVIM CONFIG - ALL IN ONE FILE
-- ==========================================

-- ==========================================
-- OPTIONS / SETTINGS
-- ==========================================

-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- UI settings
vim.opt.wrap = false
vim.opt.sidescrolloff = 8
vim.opt.colorcolumn = "80"
vim.opt.signcolumn = "yes"

-- Indentation
vim.opt.smartindent = true
vim.opt.breakindent = true

-- File handling
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Performance
vim.opt.updatetime = 50
vim.opt.timeoutlen = 300
vim.opt.lazyredraw = false

-- Clipboard and completion
vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt = "menu,noselect" -- Removed menuone for less aggressive popup

-- Splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- ==========================================
-- PLUGIN SETUP (LAZY.NVIM)
-- ==========================================

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Plugin specifications
require("lazy").setup({
    -- Colorscheme
    {
        "olimorris/onedarkpro.nvim",
        priority = 1000,
        config = function()
            require("onedarkpro").setup({
                options = {
                    transparency = true,
                }
            })
            vim.cmd("colorscheme onedark")
        end
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "lua", "javascript", "typescript", "html", "css", "json", "c", "cpp" },
                auto_install = true,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end
    },

    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
            vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Buffers' })
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
            vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = 'Recent files' })
            vim.keymap.set('n', '<leader>fs', builtin.grep_string, { desc = 'Grep string under cursor' })
        end
    },

    -- LSP Setup
    {
        'VonHeikemen/lsp-zero.nvim',
        dependencies = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'L3MON4D3/LuaSnip' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'rafamadriz/friendly-snippets' },
        }
    },

    -- File explorer
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("nvim-tree").setup({
                disable_netrw = true,
                hijack_netrw = true,
                view = {
                    width = 30,
                    side = "left",
                },
                filters = {
                    dotfiles = false,
                },
            })
        end
    },

    -- Status line
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('lualine').setup({
                options = {
                    theme = 'onedark',
                    component_separators = '|',
                    section_separators = '',
                },
            })
        end
    },

    -- Git signs
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup()
        end
    },

    -- Auto pairs
    {
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup({})
        end
    },
})

-- ==========================================
-- LSP CONFIGURATION
-- ==========================================

local lsp = require("lsp-zero")
lsp.preset("recommended")

-- Mason setup
require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

require("mason-lspconfig").setup({
    ensure_installed = {
        "ts_ls",
        "lua_ls",
        "clangd",
        "html",
        "emmet_ls",
        "jsonls",
        "cssls",
    },
    handlers = {
        lsp.default_setup,

        -- Enhanced lua_ls setup
        lua_ls = function()
            require('lspconfig').lua_ls.setup({
                settings = {
                    Lua = {
                        runtime = { version = 'LuaJIT' },
                        diagnostics = { globals = { 'vim' } },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                        telemetry = { enable = false },
                    }
                }
            })
        end,
    },
})

-- LSP keymaps and settings
lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, silent = true }
    local bind = vim.keymap.set

    -- Navigation
    bind("n", "gd", vim.lsp.buf.definition, opts)
    bind("n", "gD", vim.lsp.buf.declaration, opts)
    bind("n", "gi", vim.lsp.buf.implementation, opts)
    bind("n", "gr", vim.lsp.buf.references, opts)
    bind("n", "gt", vim.lsp.buf.type_definition, opts)

    -- Information
    bind("n", "K", vim.lsp.buf.hover, opts)
    bind("n", "<leader>k", vim.lsp.buf.signature_help, opts)

    -- Actions
    bind("n", "<leader>rn", vim.lsp.buf.rename, opts)
    bind("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    bind("v", "<leader>ca", vim.lsp.buf.code_action, opts)

    -- Diagnostics
    bind("n", "[d", vim.diagnostic.goto_prev, opts)
    bind("n", "]d", vim.diagnostic.goto_next, opts)
    bind("n", "<leader>d", vim.diagnostic.open_float, opts)
    bind("n", "<leader>q", vim.diagnostic.setloclist, opts)

    -- Formatting
    bind("n", "<leader>f", function()
        vim.lsp.buf.format({ async = true })
    end, opts)
end)

-- Configure diagnostics (minimal signs)
vim.diagnostic.config({
    virtual_text = false,   -- Disabled virtual text to reduce clutter
    float = {
        source = "if_many", -- Only show source when multiple
        border = "rounded",
    },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

-- Simple diagnostic signs using modern API
vim.diagnostic.config({
    virtual_text = false,
    float = {
        source = "if_many",
        border = "rounded",
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "E",
            [vim.diagnostic.severity.WARN] = "W",
            [vim.diagnostic.severity.HINT] = "H",
            [vim.diagnostic.severity.INFO] = "I",
        }
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

lsp.setup()

-- ==========================================
-- MINIMAL COMPLETION SETUP
-- ==========================================

local cmp = require("cmp")
local luasnip = require("luasnip")

-- Load snippets
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },

    mapping = cmp.mapping.preset.insert({
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Only confirm explicit selection
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),

    sources = cmp.config.sources({
        { name = 'nvim_lsp', keyword_length = 2 }, -- Require 2+ chars before showing LSP
        { name = 'buffer',   keyword_length = 4 }, -- Require 4+ chars for buffer completion
        { name = 'path',     keyword_length = 3 }, -- Require 3+ chars for path completion
    }),

    formatting = {
        format = function(entry, vim_item)
            -- Simple, short labels
            vim_item.menu = ({
                nvim_lsp = "LSP",
                buffer = "Buf",
                path = "Path",
            })[entry.source.name]
            return vim_item
        end,
    },

    window = {
        completion = {
            border = "none",
            max_height = 8, -- Limit height
            max_width = 40, -- Limit width for small screens
        },
        documentation = {
            border = "none",
            max_height = 6,
            max_width = 50,
        },
    },

    experimental = {
        ghost_text = false, -- Disabled ghost text to reduce distraction
    },

    completion = {
        autocomplete = false, -- Manual completion only
    },
})

-- ==========================================
-- KEYMAPS
-- ==========================================

local map = vim.keymap.set

-- File explorer
map("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Resize windows
map("n", "<C-Up>", ":resize -2<CR>", { desc = "Resize window up" })
map("n", "<C-Down>", ":resize +2<CR>", { desc = "Resize window down" })
map("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Resize window left" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Resize window right" })

-- Buffer navigation
map("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>x", ":bdelete<CR>", { desc = "Close buffer" })

-- Stay in indent mode
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Move text up and down
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move text down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move text up" })

-- Better paste
map("v", "p", '"_dP', { desc = "Paste without yanking" })

-- Clear search highlights
map("n", "<leader>h", ":nohlsearch<CR>", { desc = "Clear search highlights" })

-- Quick save and quit
map("n", "<leader>w", ":w<CR>", { desc = "Save file" })
map("n", "<leader>q", ":q<CR>", { desc = "Quit" })

-- Center cursor when jumping
map("n", "<C-d>", "<C-d>zz", { desc = "Page down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Page up and center" })
map("n", "n", "nzzzv", { desc = "Next search result and center" })
map("n", "N", "Nzzzv", { desc = "Previous search result and center" })

-- ==========================================
-- AUTO COMMANDS
-- ==========================================

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("highlight_yank", {}),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("remove_trailing_whitespace", {}),
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

-- Auto-format on save for certain filetypes
vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("format_on_save", {}),
    pattern = { "*.lua", "*.js", "*.ts", "*.jsx", "*.tsx" },
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})

-- Open NvimTree when starting with a directory
vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("nvim_tree_start", {}),
    callback = function()
        local stats = vim.loop.fs_stat(vim.fn.argv(0))
        if stats and stats.type == "directory" then
            require("nvim-tree.api").tree.open()
        end
    end,
})

print("🚀 Minimal Neovim config loaded!")
