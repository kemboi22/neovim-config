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
