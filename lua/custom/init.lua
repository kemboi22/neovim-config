local constants = require "custom.utils.constants"
local utils = require "custom.utils"

-- PERF: disable nvim syntax, which causes severe lag
-- however you can still enable it per buffer with a
-- FileType autocmd that calls `:set syntax=<filetype>`
vim.cmd.syntax "manual"

require "custom.options"
require "custom.globals"

-- lazy load ./plugins/*
require "custom.lazy"

-- lazy load ./autocmds.lua, ./keymaps.lua, ./commands.lua
if constants.has_file_arg then
  require "custom.autocmds"
end
utils.autocmd("User", {
  group = utils.augroup "load_core",
  pattern = "VeryLazy",
  callback = function()
    if not constants.has_file_arg then
      require "custom.autocmds"
    end
    require "custom.keymaps"
    require "custom.commands"
  end,
})

vim.cmd.colorscheme "onedark_dark"

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "java", "javascript", "php", "typescript", "html", "css" },
  callback = function()
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4
    vim.bo.expandtab = true -- Use spaces instead of tabs
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python" },
  callback = function()
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4
    vim.bo.expandtab = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "go" },
  callback = function()
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4
    vim.bo.expandtab = false -- Go typically uses tabs, not spaces
  end,
})

-- Global indentation settings
vim.o.autoindent = true -- Automatically indent new lines based on the previous line
vim.o.smartindent = true -- Enable smart indentation for structured languages
vim.o.smarttab = true -- Insert spaces based on 'shiftwidth' when using tabs
vim.o.shiftround = true -- Round indent to multiple of 'shiftwidth'
vim.o.expandtab = true -- Use spaces instead of tabs by default

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.blade = {
  install_info = {
    url = "https://github.com/EmranMR/tree-sitter-blade",
    files = { "src/parser.c" },
    branch = "main",
  },
  filetype = "blade",
}
parser_config.surrealdb = {
  install_info = {
    url = "https://github.com/DariusCorvus/tree-sitter-surrealdb",
    files = { "src/parser.c" },
    branch = "main",
  },
  filetype = "surql",
}
require("nvim-treesitter.configs").setup {
  ensure_installed = "blade",
  highlight = {
    enable = true,
  },
}
require("conform").setup {
  formatters_by_ft = {
    blade = { "blade-formatter" },
  },
}
vim.filetype.add {
  pattern = {
    [".*%.blade%.php"] = "blade",
  },
}

vim.filetype.add {
  pattern = {
    [".surql"] = "surql",
  },
}
vim.filetype.add {
  extension = {
    surql = "surql",
  },
}
-- in my settings
-- Filetypes --
vim.filetype.add {
  pattern = {
    [".*%.blade%.php"] = "blade",
  },
}
