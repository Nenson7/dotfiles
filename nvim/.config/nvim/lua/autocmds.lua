vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'lua', 'svelte', 'html', 'json', 'css', 'c', },
    callback = function() vim.treesitter.start() end,
})
