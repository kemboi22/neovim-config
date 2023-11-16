local M = {}

M.setup = function(opts)
  -- run LazyVim mason config
  local find_spec = require("custom.utils.lazy").find_spec
  local lazyvim_lsp_specs = require "custom.custom-plugins.external.lazyvim_plugins_lsp"
  local lazyvim_mason_spec = find_spec(lazyvim_lsp_specs, "williamboman/mason.nvim")
  lazyvim_mason_spec.config(_, opts)

  -- run NvChad mason config
  dofile(vim.g.base46_cache .. "mason")
  vim.api.nvim_create_user_command("MasonInstallAll", function()
    vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
  end, {})
  vim.g.mason_binaries_list = opts.ensure_installed
end

return M
