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
    sections = {
      untracked = {
        folded = false
      },
      unstaged = {
        folded = false
      },
      staged = {
        folded = false
      },
      stashes = {
        folded = false
      },
      unpulled = {
        folded = false
      },
      unmerged = {
        folded = false
      },
      recent = {
        folded = false
      },
    },
  }
end

return M