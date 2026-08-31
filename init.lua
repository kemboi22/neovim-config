pcall(vim.loader.enable)

require("config.options")
require("config.pack")
require("plugins")
require("config.diagnostics")
require("lsp")
require("config.autocmds")
require("config.keymaps")
