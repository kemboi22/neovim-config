vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true -- Enable 24-bit RGB colors
vim.opt.cursorline = true -- Highlight the current line
vim.opt.laststatus = 3 -- Global statusline (looks cleaner with one bar at the bottom)
vim.opt.showmode = false -- Don't show -- INSERT -- (Which-key/Statusline handle this)
-- Better Editing
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.shiftwidth = 2 -- Size of an indent
vim.opt.tabstop = 2 -- Number of spaces tabs count for
vim.opt.smartindent = true -- Insert indents automatically
vim.opt.ignorecase = true -- Ignore case in search...
vim.opt.smartcase = true -- ...unless search contains a capital letter
vim.opt.clipboard = "unnamedplus"
-- Performance & Behavior
vim.opt.updatetime = 250 -- Faster completion and diagnostic display
vim.opt.timeoutlen = 300 -- Faster Which-key popup
vim.opt.splitright = true -- Vertical splits open to the right
vim.opt.splitbelow = true
-- Inlay hints
vim.lsp.inlay_hint.enable(true)
vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#545862", italic = true, bg = "none" })

-- 2. Create an exception for TS and Vue
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf

    -- List the clients you want to DISABLE hints for
    local disabled_clients = { "vtsls", "vue_ls", "ts_ls" }

    for _, name in ipairs(disabled_clients) do
      if client.name == name then
        vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
      end
    end
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "rust", "javascript", "zig", "go", "php", "c", "cpp", "html", "lua", "json" },
  callback = function()
    -- syntax highlighting, provided by Neovim
    vim.treesitter.start()
  end,
})
vim.pack.add({
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
  { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
  { src = "https://github.com/L3MON4D3/LuaSnip" },
  { src = "https://github.com/rafamadriz/friendly-snippets" },
  { src = "https://github.com/saghen/blink.cmp" },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/olimorris/onedarkpro.nvim" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/ibhagwan/fzf-lua" },
  { src = "https://github.com/folke/which-key.nvim" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/windwp/nvim-ts-autotag" },
  { src = "https://github.com/windwp/nvim-autopairs" },
  { src = "https://github.com/mfussenegger/nvim-lint" },
})
require("onedarkpro").setup({
  options = {
    transparency = true,
  },
})
vim.cmd("colorscheme onedark")
require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
  ensure_installed = {
    "lua_ls",
    "stylua",
    "vtsls",
    "vue_ls",
    "gopls",
    "rust_analyzer",
    "zls",
    "pyright",
    "intelephense",
    "clangd",
    "bashls",
    "tailwindcss",
    "svelte",
    "prismals",
    "php-cs-fixer",
    "dockerls",
    "docker_compose_language_service",
    "jsonls",
    "oxfmt",
    "oxlint",
    "blade-formatter",
  },
})
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = {
          "vim",
          "require",
        },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
    },
  },
})
vim.lsp.enable({
  "bashls",
  "tailwindcss",
  "svelte",
  "pyright",
  "clangd",
  "zls",
  "gopls",
  "vtsls",
  "vue_ls",
  "intelephense",
  "rust_analyzer",
  "prismals",
  "dockerls",
  "docker_compose_language_service",
  "jsonls",
  "oxlint",
})
require("luasnip.loaders.from_vscode").lazy_load()
require("blink.cmp").setup({
  fuzzy = {
    implementation = "prefer_rust",
    prebuilt_binaries = { force_version = "v*", download = true },
  },
  signature = { enabled = true },
  completion = {
    documentation = { auto_show = true },
    menu = {
      auto_show = true,
    },
    list = {
      selection = { preselect = true, auto_insert = false },
    },
  },
  keymap = {
    ["<CR>"] = { "accept", "fallback" },
    ["<Tab>"] = { "select_next", "fallback" },
    ["<S-Tab>"] = { "select_prev", "fallback" },
  },
})

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    c = { "clang_format" },
    cpp = { "clang_format" },
    blade = { "blade-formatter" },
    zig = { "zigfmt" },
    go = { "gofmt", "goimports" },
    php = { "php_cs_fixer" },
    javascript = { "oxfmt", "prettierd", "prettier" },
    javascriptreact = { "oxfmt", "prettierd", "prettier" },
    typescript = { "oxfmt", "prettierd", "prettier" },
    typescriptreact = { "oxfmt", "prettierd", "prettier" },
    vue = { "oxfmt", "prettierd", "prettier" },
  },
})

local lint = require("lint")

lint.linters_by_ft = {
  javascript = { "oxlint", "eslint_d", "eslint" },
  javascriptreact = { "oxlint", "eslint_d", "eslint" },
  -- typescript = { "oxlint", "eslint_d", "eslint" },
  typescriptreact = { "oxlint", "eslint_d", "eslint" },
  -- vue = { "oxlint", "eslint_d", "eslint" },
  php = { "php" },
  go = { "golangcilint" },
  c = { "clangtidy" },
  cpp = { "clangtidy" },
  zig = { "zlint" },
}
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
  end,
})
vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
  callback = function()
    require("lint").try_lint()
  end,
})
require("oil").setup({
  default_file_explorer = true,
  delete_to_trash = true,
  skip_confirm_for_simple_edits = true,
  view_options = {
    show_hidden = true, -- Always see .dotfiles
  },
  float = {
    padding = 2,
    maxWidth = 80,
    maxHeight = 20,
    border = "rounded",
  },
  -- This makes it feel "nice": hitting <ESC> closes the editor
  keymaps = {
    ["<ESC>"] = "actions.close",
    ["q"] = "actions.close",
  },
})
local wk = require("which-key")
wk.setup({
  preset = "modern",
  win = { border = "single" },
})
wk.add({
  { "<leader>E", "<CMD>Oil<CR>", desc = "Edit Files (Oil)" },
  { "<leader>e", "<CMD>FzfLua files<CR>", desc = "Edit Files (Oil)" },
  { "<leader>f", group = "Find" }, -- Grouping for your fzf-lua
  { "<leader>ff", "<CMD>FzfLua files<CR>", desc = "Find Files" },
  { "<leader>fg", "<CMD>FzfLua live_grep<CR>", desc = "Grep Text" },
  { "<leader>q", desc = "Quit Buffer" },
  { "<leader>/", "<CMD>FzfLua live_grep<CR>", desc = "Gerp Text" },
})
wk.add({
  {
    "<leader>cl",
    function()
      require("lint").try_lint()
    end,
    desc = "Lint Buffer",
  },
  {
    "<leader>cf",
    function()
      require("conform").format({ lsp_fallback = true, async = false, timeout_ms = 500 })
    end,
    desc = "Format File",
  },
})

vim.keymap.set("n", "<Tab>", "<CMD>bnext<CR>", { desc = "Next Buffer" })
vim.keymap.set("n", "<S-Tab>", "<CMD>bprev<CR>", { desc = "Prev Buffer" })

-- Close current buffer without closing the window
vim.keymap.set("n", "<leader>q", "<CMD>bdelete<CR>", { desc = "Close Buffer" })
vim.keymap.set("n", "<leader>?", "<CMD>WhichKey<CR>", { desc = "Show all keymaps" })
require("gitsigns").setup({
  signs = {
    add = { text = "┃" },
    change = { text = "┃" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
    untracked = { text = "┆" },
  },
  -- Integrate with Which-key for easy Git actions
  on_attach = function()
    local gs = package.loaded.gitsigns

    wk.add({
      { "<leader>g", group = "Git" },
      { "<leader>gs", gs.stage_hunk, desc = "Stage Hunk" },
      { "<leader>gr", gs.reset_hunk, desc = "Reset Hunk" },
      { "<leader>gp", gs.preview_hunk, desc = "Preview Hunk" },
      {
        "<leader>gb",
        function()
          gs.blame_line({ full = true })
        end,
        desc = "Blame Line",
      },
    })
  end,
})
-- Define nice icons for diagnostics
local signs = { Error = " ", Warn = " ", Hint = "󰌵 ", Info = " " }
for type, icon in pairs(signs) do
  local name = "DiagnosticSign" .. type
  vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
end

-- Configure how diagnostics are displayed
vim.diagnostic.config({
  virtual_text = {
    prefix = "●", -- Small dot instead of giant text blocks
    spacing = 4,
  },
  signs = true,
  underline = true,
  update_in_insert = false, -- Don't show errors while typing
  severity_sort = true,
  float = {
    border = "rounded", -- Nice rounded windows for errors
  },
})

wk.add({
  {
    "[d",
    function()
      vim.diagnostic.jump({ count = -1, float = true })
    end,
    desc = "Previous Diagnostic",
  },
  {
    "]d",
    function()
      vim.diagnostic.jump({ count = 1, float = true })
    end,
    desc = "Next Diagnostic",
  },
  { "<leader>d", group = "Diagnostics" },
  { "<leader>dl", vim.diagnostic.setloclist, desc = "List Diagnostics" },
  { "<leader>df", vim.diagnostic.open_float, desc = "Float Error" },
})
-- require("nvim-treesitter").install({
--   "lua",
--   "vue",
--   "vim",
--   "vimdoc",
--   "query",
--   "javascript",
--   "typescript",
--   "json",
--   "go",
--   "python",
--   "zig",
--   "rust",
--   "php",
--   "c",
--   "cpp",
--   "html",
--   "sql",
--   "json",
-- })
-- require("nvim-treesitter.config").setup()
-- require("nvim-treesitter.config").setup({
--   install_dir = vim.fn.stdpath("data") .. "/site",
--   ensure_installed = {
-- "lua",
-- "vue",
-- "vim",
-- "vimdoc",
-- "query",
-- "javascript",
-- "typescript",
-- "json",
-- "go",
-- "python",
-- "zig",
-- "rust",
-- "php",
-- "c",
-- "cpp",
--   },
--   auto_install = true,
--   highlight = { enable = true, additional_vim_regex_highlighting = false },
--   indent = { enable = true },
-- })

require("nvim-ts-autotag").setup({
  opts = {
    -- Defaults
    enable_close = true, -- Auto close tags
    enable_rename = true, -- Auto rename pairs of tags
    enable_close_on_slash = false, -- Auto close on trailing </
  },
})
wk.add({
  { "<leader>c", group = "Code" },
  { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" } },
  { "<leader>cr", vim.lsp.buf.rename, desc = "Rename Symbol" },
  { "gd", vim.lsp.buf.definition, desc = "Go to Definition" },
  { "gr", vim.lsp.buf.references, desc = "Show References" },
  { "K", vim.lsp.buf.hover, desc = "Hover Docs" },
})
local autopairs = require("nvim-autopairs")
autopairs.setup({
  check_ts = true,
  fast_wrap = {},
})
