require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "clangd", "vtsls", "svelte" }

vim.lsp.config("clangd", {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=llvm",
  },
  root_markers = { ".git", "compile_commands.json", "compile_flags.txt" },
})
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
