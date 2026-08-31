-- Set up autopairs first so Blink's <CR> fallback can reach its smart-newline mapping.
require("nvim-autopairs").setup({
  check_ts = true,
  fast_wrap = {},
})

require("blink.cmp").setup({
  fuzzy = { implementation = "prefer_rust" },
  signature = { enabled = true },
  snippets = { preset = "default" },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 200 },
    menu = { auto_show = true },
    list = { selection = { preselect = true, auto_insert = false } },
  },
  keymap = {
    preset = "none",
    ["<CR>"] = { "accept", "fallback" },
    ["<Down>"] = { "select_next", "fallback" },
    ["<Up>"] = { "select_prev", "fallback" },
    ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
    ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
    ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
    ["<C-e>"] = { "hide", "fallback" },
  },
})
