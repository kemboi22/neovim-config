local M = {}

M.conflict_marker = function()
  local g = vim.g

  -- Include text after begin and end markers
  g.conflict_marker_begin = '^<<<<<<< .*$'
  g.conflict_marker_end = '^>>>>>>> .*$'
end

M.emmet_vim = function()
  local g = vim.g
end

return M