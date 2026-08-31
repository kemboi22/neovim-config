local M = {}

M.big_file_size = 1024 * 1024

function M.is_big_file(bufnr)
  bufnr = bufnr or 0
  local name = vim.api.nvim_buf_get_name(bufnr)
  local stat = name ~= "" and vim.uv.fs_stat(name) or nil
  return stat ~= nil and stat.size > M.big_file_size
end

function M.find_upward(names, path)
  return vim.fs.find(names, {
    upward = true,
    path = path or vim.fn.expand("%:p:h"),
  })[1]
end

return M
