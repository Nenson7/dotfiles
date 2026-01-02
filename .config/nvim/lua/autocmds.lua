require "nvchad.autocmds"

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    if vim.bo.buftype ~= "" then return end

    local row, col = unpack(vim.api.nvim_buf_get_mark(0, '"'))
    if row > 0 and row <= vim.api.nvim_buf_line_count(0) then
      vim.api.nvim_win_set_cursor(0, { row, col })
    end
  end,
})

