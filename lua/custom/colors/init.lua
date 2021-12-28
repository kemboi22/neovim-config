local colors = require("colors").get()
local theme = require("core.utils").load_config().ui.theme
local present, base16 = pcall(require, "base16")
local themeColors = base16.themes(theme)

-- Add # sign
for name, color in pairs(themeColors) do
   themeColors[name] = "#" .. color
end

local function highlight(group, color)
  local style = color.style and "gui=" .. color.style or "gui=NONE"
  local fg = color.fg and "guifg=" .. color.fg or "guifg=NONE"
  local bg = color.bg and "guibg=" .. color.bg or "guibg=NONE"
  local sp = color.sp and "guisp=" .. color.sp or ""
 
  local hl = "highlight " .. group .. " " .. style .. " " .. fg .. " " .. bg .. " " .. sp
 
  if color.link then
     vim.cmd("highlight! link " .. group .. " " .. color.link)
  else
     vim.cmd(hl)
  end
end

local syntax = {
   -- diffAdded
   -- diffChanged
   -- diffChanged
   -- diffFile
   -- diffIndexLine
   -- diffLine
   -- diffNewFile
   -- diffOldFile
   -- diffRemoved

   -- DiffChangeDelete = { bg = "#ffffff" },
   -- DiffModified = { bg = "#ffffff" },

   -- DiffAdded = { bg = "#ffffff" },
   -- DiffFile = { bg = "#ffffff" },
   -- DiffLine = { bg = "#ffffff" },
   -- DiffNewFile = { bg = "#ffffff" },
   -- DiffRemoved = { bg = "#ffffff" },
   
   ConflictMarkerBegin = {bg = "#347a71", fg = "#abb2bf" },
   ConflictMarkerOurs = {bg = "#2d4b4d"},
   ConflictMarkerTheirs = {bg = "#2d445d"},
   ConflictMarkerEnd = {bg = "#366b9e", fg = "#abb2bf" },
   ConflictMarkerCommonAncestorsHunk = {bg = "#754a81"},
   ConflictMarkerSeparator = {fg = themeColors.base0B},
   
   -- Git signs
   GitSignsAdd = { fg = "#109868" },
   GitSignsChange = { fg = "#526c9f" },
   GitSignsDelete = { fg = "#9a353d" },
   
   -- Diffview
   DiffAdd = { bg = "#20303b" }, -- right diff add
   DiffChange = { bg = "#232c4c" }, -- both diff change line
   DiffDelete = { bg = "#4a262e" }, -- right delete
   DiffText = { bg = "#33406b" }, -- both diff change text
   DiffviewDiffAddAsDelete = { bg = "#4a262e" }, -- left diff delete
   DiffviewDiffDelete = { fg = themeColors.base03 }, -- both diff delete sign
   DiffviewFilePanelCounter = { fg = colors.blue, bg = "NONE" },
   DiffviewFilePanelTitle = { fg = colors.red, bg = "NONE" },
   -- DiffviewFilePanelFileName = { fg = , bg = },
   -- DiffviewNormal = { fg = , bg = },
   -- DiffviewCursorLine = { fg = , bg = },
   -- DiffviewVertSplit = { fg = , bg = },
   -- DiffviewSignColumn = { fg = , bg = },
   -- DiffviewStatusLine = { fg = , bg = },
   -- DiffviewStatusLineNC = { fg = , bg = },
   -- DiffviewEndOfBuffer = { fg = , bg = },
   -- DiffviewFilePanelRootPath = { fg = , bg = },
   -- DiffviewFilePanelPath = { fg = , bg = },
   -- DiffviewFilePanelInsertions = { fg = , bg = },
   -- DiffviewFilePanelDeletions = { fg = , bg = },
   -- DiffviewStatusAdded = { fg = , bg = },
   -- DiffviewStatusUntracked = { fg = , bg = },
   -- DiffviewStatusModified = { fg = , bg = },
   -- DiffviewStatusRenamed = { fg = , bg = },
   -- DiffviewStatusCopied = { fg = , bg = },
   -- DiffviewStatusTypeChange = { fg = , bg = },
   -- DiffviewStatusUnmerged = { fg = , bg = },
   -- DiffviewStatusUnknown = { fg = , bg = },
   -- DiffviewStatusDeleted = { fg = , bg = },
   -- DiffviewStatusBroken = { fg = , bg = },

   -- Neogit
   NeogitDiffAdd = { fg = themeColors.base0B },
   NeogitDiffAddHighlight = { fg = "#abb2bf", bg = "#1a4b59" },
   NeogitDiffContext = { fg = themeColors.base05 },
   NeogitDiffContextHighlight = { fg = themeColors.base05, bg = colors.darker_black },
   NeogitDiffDelete = { fg = themeColors.base08 },
   NeogitDiffDeleteHighlight = { fg = "#abb2bf", bg = "#751c22" },
   NeogitHunkHeader = { fg = themeColors.base0A, bg = colors.black },
   NeogitHunkHeaderHighlight ={ fg = themeColors.base0A, bg = colors.darker_black },
   -- NeogitBranch = { fg = , bg = },
   -- NeogitRemote = { fg = , bg = },

   -- Pmenu
   CmpItemAbbrMatch = { fg = themeColors.base0C },
   -- CmpItemAbbr = { fg = colors.grey_fg },

   -- LSP
   LspReferenceRead = { bg = "#343a46" }, -- highlight for refecences
   -- LspReferenceText = { bg = colors.red },
   -- LspReferenceWrite = { bg = colors.yellow },

   -- Others
   EndOfBuffer = { fg = colors.grey },
}

for group, colors in pairs(syntax) do
   highlight(group, colors)
end
