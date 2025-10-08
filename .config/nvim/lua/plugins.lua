local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        "rose-pine/neovim",
        name = "rose-pine",
        priority = 1000,
        config = function ()
            require("rose-pine").setup({
                styles = {
                    italic = false,
                    transparency = true,
                },
            })
            vim.cmd.colorscheme("rose-pine")
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "c", "lua", "vim", "vimdoc" },
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
            })
        end
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function ()
            require("lualine").setup()
        end
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-fzf-native.nvim" },
        build = "make",
        config = function()
            local telescope = require("telescope")
            local builtin = require("telescope.builtin")
            local map = vim.keymap.set

            telescope.setup{
                defaults = {
                    prompt_prefix = "❯ ",
                    selection_caret = "➤ ",
                    sorting_strategy = "ascending",
                    layout_config = { prompt_position = "top" },
                    file_ignore_patterns = { "node_modules", ".git/" },
                    path_display = { "truncate" },
                },
                extensions = {
                    fzf = {
                        fuzzy = true,                    -- enable fuzzy search
                        override_generic_sorter = true,  -- override default sorter
                        override_file_sorter = true,     -- override file sorter
                        case_mode = "smart_case",        -- smart case sensitivity
                    }
                }
            }

            telescope.load_extension("fzf")

            map("n", "<leader>ff", function ()
                builtin.find_files({hidden = true})
            end, { desc = "Find files" , silent = true})

            map("n", "<leader>fg", function ()
                builtin.live_grep()
            end , { desc = "Live grep", silent = true})

            map("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
            map("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
        end
    },

    { "neovim/nvim-lspconfig" },
    { "hrsh7th/cmp-nvim-lsp" },

    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = true,
    },

    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "buffer", max_item_count = 10 },
                    { name = "path" },
                }),
                window = {
                    completion = cmp.config.window.bordered({
                        border = "single",
                    }),
                    documentation = cmp.config.window.bordered({
                        border = "single",
                    })
                },
                completion = {
                    completeopt = "menu,menuone,noselect",
                },
                formatting = {
                    side_padding = 1,  -- increase/decrease horizontal padding
                    col_offset = 1,    -- offset text from border
                },
            })
        end,
    },

    { 'windwp/nvim-autopairs' , event = "InsertEnter", config = true },

    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp"
        },
        config = function()
            local mason_lspconfig = require("mason-lspconfig")
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local on_attach = function(_, bufnr)
                local map = function(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
                end
                map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
                map("n", "K", vim.lsp.buf.hover, "Hover Docs")
                map("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
                map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
                map("n", "gr", vim.lsp.buf.references, "References")
            end

            mason_lspconfig.setup({
                ensure_installed = { "lua_ls", "clangd" },
                handlers = {
                    function(server_name)
                        lspconfig[server_name].setup({
                            on_attach = on_attach,
                            capabilities = capabilities,
                            settings = server_name == "lua_ls" and {
                                Lua = {
                                    diagnostics = { globals = { "vim" } },
                                    telemetry = { enable = false },
                                    runtime = { version = "LuaJIT" },
                                    workspace = { library = vim.api.nvim_get_runtime_file("", true) },
                                } or nil,
                            }
                        })
                    end,
                },
            })
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("gitsigns").setup({
                signs = {
                    add          = { text = '+' },
                    change       = { text = '~' },
                    delete       = { text = '_' },
                    topdelete    = { text = '‾' },
                    changedelete = { text = '~' },
                },
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns
                    local map = vim.keymap.set

                    -- Navigation
                    map('n', ']c', gs.next_hunk, { buffer = bufnr, desc = "Next Git hunk" })
                    map('n', '[c', gs.prev_hunk, { buffer = bufnr, desc = "Previous Git hunk" })

                    -- Actions
                    map('n', '<leader>hs', gs.stage_hunk, { buffer = bufnr, desc = "Stage hunk" })
                    map('n', '<leader>hr', gs.reset_hunk, { buffer = bufnr, desc = "Reset hunk" })
                    map('v', '<leader>hs', function() gs.stage_hunk({vim.fn.line('.'), vim.fn.line('v')}) end, { buffer = bufnr, desc = "Stage selection" })
                    map('v', '<leader>hr', function() gs.reset_hunk({vim.fn.line('.'), vim.fn.line('v')}) end, { buffer = bufnr, desc = "Reset selection" })
                    map('n', '<leader>hS', gs.stage_buffer, { buffer = bufnr, desc = "Stage buffer" })
                    map('n', '<leader>hu', gs.undo_stage_hunk, { buffer = bufnr, desc = "Undo stage hunk" })
                    map('n', '<leader>hp', gs.preview_hunk, { buffer = bufnr, desc = "Preview hunk" })
                    map('n', '<leader>hb', gs.blame_line, { buffer = bufnr, desc = "Blame line" })
                end,
            })
        end
    },
    {
        "kdheepak/lazygit.nvim",
        cmd = "LazyGit",  -- lazy-load only when you run :LazyGit
        config = function()
            vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { desc = "Open LazyGit" })
        end
    },
})

-- Optional: Configure diagnostics display
vim.diagnostic.config({
    virtual_text = {
        prefix = '●', -- or '■', '▎', etc
    },
    signs = false,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})
