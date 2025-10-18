-- bootstrap lazy.nvim
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
  -- Colorscheme
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    config = function()
      require("rose-pine").setup({ styles = { italic = false, transparency = true } })
      vim.cmd.colorscheme("rose-pine")
    end
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "markdown", "markdown_inline" },
        auto_install = true,
        highlight = { enable = true, additional_vim_regex_highlighting = false },
        indent = { enable = true },
      })
    end
  },

  -- Lualine
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require("lualine").setup()
    end
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }
    },
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")
      local map = vim.keymap.set

      telescope.setup({
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
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case"
          }
        }
      })

      telescope.load_extension("fzf")

      map("n", "<leader>ff", function() builtin.find_files({ hidden = true }) end, { desc = "Find files" })
      map("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
      map("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
      map("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
    end
  },

  -- Mason
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup({
        ui = {
          border = "single",
        }
      })
    end
  },

  -- Mason LSPConfig
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "clangd" },
        automatic_installation = true,
      })
    end
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- LSP keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf, silent = true }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Goto Definition" }))
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Goto Declaration" }))
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Goto Implementation" }))
          vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover Docs" }))
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
          vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code Action" }))
          vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "References" }))
          vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Line Diagnostics" }))
            vim.keymap.set("n", "[d", function()
              vim.diagnostic.jump({ count = -1, float = true })
            end, vim.tbl_extend("force", opts, { desc = "Previous Diagnostic" }))

            vim.keymap.set("n", "]d", function()
              vim.diagnostic.jump({ count = 1, float = true })
            end, vim.tbl_extend("force", opts, { desc = "Next Diagnostic" }))
        end,
      })

      -- Server configurations
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = {
              library = {
                vim.env.VIMRUNTIME,
                "${3rd}/luv/library",
              },
              checkThirdParty = false,
            },
            telemetry = { enable = false },
            format = { enable = false },
          },
        },
      })

      vim.lsp.config("clangd", {
        capabilities = capabilities,
      })

      -- Enable servers
      vim.lsp.enable("lua_ls")
      vim.lsp.enable("clangd")
    end
  },
  -- Debugging (DAP + inline runtime values using LLDB)
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",           -- JetBrains-style UI (stack, vars, breakpoints)
      "theHamsta/nvim-dap-virtual-text", -- inline values beside code,
      "nvim-neotest/nvim-nio"
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Inline variable values beside code
      require("nvim-dap-virtual-text").setup({
        commented = true, -- shows like: int x = 5; // x = 5
      })

      -- DAP UI setup (optional but really useful)
      dapui.setup()

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      dap.adapters.lldb = {
        type = "executable",
        command = "lldb-dap", -- installed with lldb package
        name = "lldb",
      }

      dap.configurations.cpp = {
        {
          name = "Launch with LLDB",
          type = "lldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        args = function ()
          local input = vim.fn.input("Program Arguments: ")
          return vim.fn.split(input, " ")
        end
        },
      }

      dap.configurations.c = dap.configurations.cpp

      local map = vim.keymap.set
      map("n", "<F5>", function() dap.continue() end, { desc = "Start / Continue Debugging" })
      map("n", "<F10>", function() dap.step_over() end, { desc = "Step Over" })
      map("n", "<F11>", function() dap.step_into() end, { desc = "Step Into" })
      map("n", "<F12>", function() dap.step_out() end, { desc = "Step Out" })
      map("n", "<leader>db", function() dap.toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
      map("n", "<leader>du", function() dapui.toggle() end, { desc = "Toggle DAP UI" })
    end,
  },


  -- Completion
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
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer", max_item_count = 10 },
          { name = "path" },
        }),
        window = {
          completion = cmp.config.window.bordered({ border = "single" }),
          documentation = cmp.config.window.bordered({ border = "single" }),
        },
        formatting = {
          fields = { "abbr", "kind", "menu" },
          format = function(entry, item)
            item.menu = ({
              nvim_lsp = "[LSP]",
              luasnip = "[Snip]",
              buffer = "[Buf]",
              path = "[Path]",
            })[entry.source.name]
            return item
          end,
        },
      })
    end
  },

  -- Autopairs
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = function()
      local autopairs = require("nvim-autopairs")
      autopairs.setup()

      -- Integration with nvim-cmp
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end
  },

  -- Comment
  {
    'numToStr/Comment.nvim',
    keys = {
      { "<leader>/", mode = { "n", "v" }, desc = "Toggle comment" }
    },
    config = function()
      require('Comment').setup({
        toggler = {
          line = '<leader>/',
          block = '<leader>?',
        },
        opleader = {
          line = '<leader>/',
          block = '<leader>?',
        },
      })
    end
  },
  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local map = vim.keymap.set
          map('n', ']c', gs.next_hunk, { buffer = bufnr, desc = "Next Git hunk" })
          map('n', '[c', gs.prev_hunk, { buffer = bufnr, desc = "Previous Git hunk" })
          map('n', '<leader>hs', gs.stage_hunk, { buffer = bufnr, desc = "Stage hunk" })
          map('n', '<leader>hr', gs.reset_hunk, { buffer = bufnr, desc = "Reset hunk" })
          map('v', '<leader>hs', function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, { buffer = bufnr, desc = "Stage selection" })
          map('v', '<leader>hr', function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, { buffer = bufnr, desc = "Reset selection" })
          map('n', '<leader>hS', gs.stage_buffer, { buffer = bufnr, desc = "Stage buffer" })
          map('n', '<leader>hu', gs.undo_stage_hunk, { buffer = bufnr, desc = "Undo stage hunk" })
          map('n', '<leader>hp', gs.preview_hunk, { buffer = bufnr, desc = "Preview hunk" })
          map('n', '<leader>hb', gs.blame_line, { buffer = bufnr, desc = "Blame line" })
        end,
      })
    end
  },

  -- Lazygit
  {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "Open LazyGit" }
    },
  },
},
  {
    ui = {
      border = "single",
    }
  })

-- Diagnostics
vim.diagnostic.config({
  virtual_text = { prefix = '●' },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "single",
    source = "if_many",
  },
})

-- vim.lsp.inlay_hint.enable(true)
