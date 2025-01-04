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
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
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

require "parsers.parser"
vim.schedule(function()
  require "mappings"
end)
vim.api.nvim_set_keymap('n', 'o', 'o<CR>  ', { noremap = true, silent = true })

local cmp = require("cmp")

cmp.setup({
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" }
  }
})
cmp.setup.cmdline(":", {
  sources = cmp.config.sources({
    { name = "cmdline" },
    { name = "buffer" }
  })
})
