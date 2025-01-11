require "nvchad.mappings"
local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
-- add yours here
vim.keymap.set("n", "<leader>fp", function()
  require("conform").format({ async = true })
end, { desc = "Format PHP file" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
