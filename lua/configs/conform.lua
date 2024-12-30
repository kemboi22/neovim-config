local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettierd" },
    html = { "prettierd" },
    php = { "php-cs-fixer" },
    vue = { "prettierd" },
    json = { "prettierd" },
    typescript = { "prettierd" },
    yaml = { "prettierd" },
    markdown = { "prettierd" },
    go = { "goimports_reviser", "gofumpt", "golines" },
      sh = { "shfmt" },
    python = { "isort", "black" }


  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
