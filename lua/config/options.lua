-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.lazyvim_picker = "telescope"
vim.g.lazyvim_php_lsp = "intelephense"
vim.env.PHP_CS_FIXER_IGNORE_ENV = "1"
vim.lsp.inlay_hint.enable(false)
