local map = vim.keymap.set

map("n", "<leader>E", "<cmd>Oil<cr>", { desc = "Edit Files (Oil)" })
map("n", "<leader>e", "<cmd>FzfLua files<cr>", { desc = "Find Files" })
map("n", "<leader>ff", "<cmd>FzfLua files<cr>", { desc = "Find Files" })
map("n", "<leader>fg", "<cmd>FzfLua live_grep<cr>", { desc = "Grep Text" })
map("n", "<leader>/", "<cmd>FzfLua live_grep<cr>", { desc = "Grep Text" })

map("n", "<leader>cf", function()
  require("conform").format({ async = false, timeout_ms = 2000, lsp_format = "fallback" })
end, { desc = "Format File" })
map("n", "<leader>cl", function()
  require("lint").try_lint()
end, { desc = "Lint Buffer" })

map("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
map("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
for index = 1, 9 do
  map("n", "<leader>" .. index, "<cmd>BufferLineGoToBuffer " .. index .. "<cr>", { desc = "Buffer " .. index })
  map("n", "<leader>b" .. index, "<cmd>BufferLineGoToBuffer " .. index .. "<cr>", { desc = "Buffer " .. index })
end
map("n", "<leader>be", "<cmd>FzfLua buffers<cr>", { desc = "Fuzzy Find Buffers" })
map("n", "<leader>bq", "<cmd>%bd!<cr>", { desc = "Close All Buffers" })
map("n", "<leader>bn", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bp", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
map("n", "<leader>bc", "<cmd>bdelete<cr>", { desc = "Close Buffer" })
map("n", "<leader>q", "<cmd>bdelete<cr>", { desc = "Close Buffer" })
map("n", "<leader>?", "<cmd>WhichKey<cr>", { desc = "Show all keymaps" })

map("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Previous Diagnostic" })
map("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next Diagnostic" })
map("n", "<leader>df", vim.diagnostic.open_float, { desc = "Float Error" })
map("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "List Diagnostics" })

map("n", "<leader>ng", function()
  require("neogen").generate()
end, { desc = "Generate Docstring" })
map("n", "<leader>nf", function()
  require("neogen").generate({ type = "func" })
end, { desc = "Generate Function Docstring" })
map("n", "<leader>nt", function()
  require("neogen").generate({ type = "type" })
end, { desc = "Generate Type Docstring" })

map("n", "<leader>tt", function()
  require("fzf-lua").todo()
end, { desc = "Find Todos" })
map("n", "<leader>tf", function()
  require("todo-comments").fzf()
end, { desc = "Find Todos (todo-comments)" })

map({ "n", "x" }, "s", function()
  require("flash").jump()
end, { desc = "Flash Jump" })

require("which-key").add({
  { "<leader>b", group = "Buffers" },
  { "<leader>c", group = "Code" },
  { "<leader>d", group = "Diagnostics" },
  { "<leader>f", group = "Find" },
  { "<leader>g", group = "Git" },
  { "<leader>n", group = "Neogen" },
  { "<leader>t", group = "Todo" },
})
