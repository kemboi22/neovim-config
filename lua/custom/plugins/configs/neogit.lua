local present, neogit = pcall(require, "neogit")
if not present then
   return
end

local M = {}

M.setup = function(on_attach)
  neogit.setup {
    integrations = {
      diffview = true,
    },
    signs = {
      section = { "", "" },
      item = { "", "" },
      hunk = { "", "" },
    },
  }
end

return M