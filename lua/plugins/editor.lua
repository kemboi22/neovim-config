require("oil").setup({
  default_file_explorer = true,
  delete_to_trash = true,
  skip_confirm_for_simple_edits = true,
  view_options = { show_hidden = true },
  float = { padding = 2, max_width = 80, max_height = 20, border = "rounded" },
  keymaps = {
    ["<Esc>"] = "actions.close",
    q = "actions.close",
  },
})

require("grug-far").setup()

require("gitsigns").setup({
  signs = {
    add = { text = "┃" },
    change = { text = "┃" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
    untracked = { text = "┆" },
  },
  on_attach = function(bufnr)
    local gs = require("gitsigns")
    local function map(lhs, rhs, desc)
      vim.keymap.set({ "n", "v" }, lhs, rhs, { buffer = bufnr, desc = desc })
    end
    map("<leader>gs", gs.stage_hunk, "Stage Hunk")
    map("<leader>gr", gs.reset_hunk, "Reset Hunk")
    map("<leader>gp", gs.preview_hunk, "Preview Hunk")
    map("<leader>gb", function()
      gs.blame_line({ full = true })
    end, "Blame Line")
  end,
})

require("nvim-treesitter.config").setup({
  install_dir = vim.fn.stdpath("data") .. "/site",
  indent = { enable = true },
})

local parsers = {
  "bash",
  "c",
  "cpp",
  "css",
  "dockerfile",
  "go",
  "html",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "odin",
  "php",
  "prisma",
  "python",
  "query",
  "rust",
  "sql",
  "svelte",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "vue",
  "yaml",
  "zig",
}

vim.schedule(function()
  require("nvim-treesitter").install(parsers)
end)

require("nvim-ts-autotag").setup({
  opts = {
    enable_close = true,
    enable_rename = true,
    enable_close_on_slash = false,
  },
})

require("neogen").setup({ snippet_engine = "nvim" })
require("flash").setup({ modes = { search = { enabled = true } } })

require("ibl").setup({
  indent = { char = "│", tab_char = "│", highlight = "IblIndent" },
  scope = { enabled = true, show_start = false, show_end = false, highlight = "IblScope" },
  exclude = {
    buftypes = { "terminal", "nofile" },
    filetypes = { "help", "dashboard", "oil" },
  },
})
