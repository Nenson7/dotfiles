-- 1. Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- 2. Setup plugins
require("lazy").setup({
    -- Colorscheme
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            require("rose-pine").setup({
                styles = {
                    italic = false,
                    transparency = true
                },
            })
            vim.cmd("colorscheme rose-pine")
        end
    },

    -- Treesitter for syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require'nvim-treesitter'.install { 'c', 'lua', 'html', 'css', 'javascript', 'typescript', 'svelte' }
        end
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {
            indent = { char = "▏" },
            scope = { enabled = true, show_start = false, show_end = false},
        }
    },

    {
        "folke/trouble.nvim",
        opts = {
            use_diagnostic_signs = true,
        },
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
        },
    },

    {
        "numToStr/Comment.nvim",
        opts = {}, -- Works out of the box with 'gcc' and 'gc' in visual mode
    },

    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local builtin = require('telescope.builtin')
            -- Basic Keybindings
            vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
            vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
            vim.keymap.set('n', '<leader>gs', builtin.git_status, {}) -- Git integration
            require('telescope').setup({
                defaults = {
                    entry_prefix = "  ",
                    prompt_prefix = "> ",
                    selection_caret = "> ",
                }
            })
        end
    },

    -- File Explorer (Oil.nvim)
    {
        "stevearc/oil.nvim",
        opts = {
            columns = { "icon" }, -- Note: Will show default folder/file indicators without devicons
            use_default_keymaps = true,
            view_options = { show_hidden = true },
        },
    },

    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
            { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
            { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
            { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
        },
    },

    -- Statusline (Lualine)
    {
        "nvim-lualine/lualine.nvim",
        opts = {
            options = {
                icons_enabled = false, -- Disabling icons as requested
                theme = "rose-pine",
                component_separators = "|",
                section_separators = "",
            },
        },
    },

    -- Autopairs
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {}
    },

    -- LSP Configuration & Mason
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            require("mason").setup()

            local server = { 'lua_ls', 'svelte', 'html', 'cssls', 'vtsls'}
            require("mason-lspconfig").setup({
                ensure_installed = server, -- Add more servers here
            })

            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(e)
                    local opts = { buffer = e.buf }
                    -- gd: Go to Definition
                    vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
                    -- gR: Rename (Standard behavior is often 'rn', but mapped to gR as requested)
                    vim.keymap.set('n', 'gR', function() vim.lsp.buf.rename() end, opts)
                    -- gr: References (See where code is used)
                    vim.keymap.set('n', 'gr', function() vim.lsp.buf.references() end, opts)
                    -- K: Hover documentation
                    vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
                end,
            })

            vim.diagnostic.config({
                virtual_text = {
                    prefix = '■',-- or '>>'
                    spacing = 4,
                },
                signs = true,
                underline = true,
                update_in_insert = false, -- Only update diagnostics when you leave insert mode
                severity_sort = true,
            })

            -- Setup lua_ls as an example
            vim.lsp.config("lua_ls", {
                capabilities = capabilities,
                settings = {
                    Lua = { diagnostics = { globals = { "vim" } } }
                }
            })

            vim.lsp.config("*", {
                capabilities = capabilities,
            })

            vim.lsp.enable(server)
        end
    },

    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require('gitsigns').setup({
                signs = {
                    add          = { text = '+' },
                    change       = { text = '~' },
                    delete       = { text = '-' },
                    topdelete    = { text = '‾' },
                    changedelete = { text = '~' },
                    untracked    = { text = '?' },
                },
                current_line_blame = true, -- Shows who wrote the line inline
            })
        end
    },

    -- Completion Engine (Cmp)
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
                        else fallback() end
                    end, { 'i', 's' }),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                }, {
                    { name = 'buffer' },
                    { name = 'path' },
                })
            })
        end
    },
})
