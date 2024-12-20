local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
local null_ls = require "null-ls"

local opts = {
  sources = {
    null_ls.builtins.formatting.prettierd,
    -- null_ls.builtins.formatting.phpcbf,
    -- null_ls.builtins.diagnostics.phpstan,
    -- null_ls.builtins.formatting.pint,
    -- null_ls.builtins.formatting.pretty_php,
    null_ls.builtins.formatting.goimports_reviser,
    null_ls.builtins.formatting.gofumpt,
    null_ls.builtins.formatting.golines,
    null_ls.builtins.formatting.blade_formatter,
    -- null_ls.builtins.formatting.
  },
  on_attach = function(client, bufnr)
    if client.supports_method "textDocument/formatting" then
      vim.api.nvim_clear_autocmds {
        group = augroup,
        buffer = bufnr,
      }
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format { bufnr = bufnr }
        end,
      })
    end
  end,
}

return opts
