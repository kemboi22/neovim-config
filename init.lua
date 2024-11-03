vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"
require("nvim-tree").setup {
  git = {
    enable = true,
    ignore = false,
  },
  filters = {
    dotfiles = false,
  },
}

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
vim.cmd [[
  autocmd BufRead,BufNewFile *.php lua vim.lsp.start_client({ root_dir = vim.loop.cwd() })
]]
vim.schedule(function()
  require "mappings"
end)
