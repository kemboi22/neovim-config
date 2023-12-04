-- code necessary to integrate LazyVim in NvChad

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- LazyVim code to make formatting work in NvChad
vim.o.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()"
autocmd("User", {
  group = augroup("LazyVim", { clear = true }),
  pattern = "VeryLazy",
  callback = function()
    local Util = require "lazyvim.util"
    Util.format.setup()
  end,
})

-- LazyVim code to add LazyFile event to specs
require("lazyvim.util.plugin").lazy_file()

local lsp_specs = require "lazyvim.plugins.lsp.init"
return vim.list_extend({
  {
    "folke/lazy.nvim",
    version = "*",
  },
  -- LazyVim code to be able to import files from LazyVim
  {
    "LazyVim/LazyVim",
    lazy = false,
    version = false,
    commit = "68ff818a5bb7549f90b05e412b76fe448f605ffb",
    priority = 10000,
    config = function() end,
    cond = true,
  },
}, lsp_specs)
