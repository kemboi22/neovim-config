-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Open Telescope file finder with <leader>e (includes hidden files)
vim.keymap.set("n", "<leader>e", function()
  require("telescope.builtin").find_files({ hidden = true })
end, { desc = "Find files (Telescope)" })
