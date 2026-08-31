local util = require("config.util")

local general = vim.api.nvim_create_augroup("config_general", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = general,
  callback = function(args)
    if util.is_big_file(args.buf) then
      vim.b[args.buf].bigfile = true
      return
    end
    pcall(vim.treesitter.start, args.buf)
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = general,
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = general,
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 1 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
