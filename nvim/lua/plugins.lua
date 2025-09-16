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
        config = function()
            require("rose-pine").setup({
                styles = {
                    bold = true,
                    italic = false,
                    transparency = true,
                }
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
                highlight = { enable = true },
                additional_vim_regex_highlighting = false,
            })
        end
    },

    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local builtin = require("telescope.builtin")
            local map = vim.keymap.set
            map("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
            map("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
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
                    { name = "buffer" },
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
                    max_item_count = 10,
                },
                formatting = {
                    side_padding = 0,  -- increase/decrease horizontal padding
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
                        })
                    end,
                },
            })
        end,
    },

})

-- Define custom diagnostic signs
local signs = {
    Error = "",
    Warn  = "",
    Info  = "",
    Hint  = "",
}

for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

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
