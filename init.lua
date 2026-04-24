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
  pattern = "*", -- Let treesitter decide if it has a parser; it no-ops if not
  callback = function(args)
    local ok = pcall(vim.treesitter.start, args.buf)
    if not ok then
      -- No parser for this filetype, fall back silently
    end
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
  { src = "https://github.com/akinsho/bufferline.nvim" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/danymat/neogen" },
  { src = "https://github.com/folke/flash.nvim" },
  { src = "https://github.com/lukas-reineke/indent-blankline.nvim" },
  { src = "https://github.com/folke/todo-comments.nvim" },
  { src = "https://github.com/folke/noice.nvim" },
  { src = "https://github.com/MunifTanjim/nui.nvim" },
  { src = "https://codeberg.org/ziglang/zig.vim" },
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
vim.lsp.config("vue_ls", {
  filetypes = { "vue" },
  init_options = {
    vue = {
      hybridMode = true,
    },
  },
  on_init = function(client)
    client.handlers["tsserver/request"] = function(_, result, context)
      local ts_clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = "ts_ls" })
      local vtsls_clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = "vtsls" })
      local clients = {}

      vim.list_extend(clients, ts_clients)
      vim.list_extend(clients, vtsls_clients)

      if #clients == 0 then
        vim.notify(
          "Could not find `vtsls` or `ts_ls` lsp client, `vue_ls` would not work without it.",
          vim.log.levels.ERROR
        )
        return
      end
      local ts_client = clients[1]

      local param = unpack(result)
      local id, command, payload = unpack(param)
      ts_client:exec_cmd({
        title = "vue_request_forward", -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
        command = "typescript.tsserverRequest",
        arguments = {
          command,
          payload,
        },
      }, { bufnr = context.bufnr }, function(_, r)
        local response = r and r.body
        -- TODO: handle error or response nil here, e.g. logging
        -- NOTE: Do NOT return if there's an error or no response, just return nil back to the vue_ls to prevent memory leak
        local response_data = { { id, response } }

        ---@diagnostic disable-next-line: param-type-mismatch
        client:notify("tsserver/response", response_data)
      end)
    end
  end,
  settings = {
    typescript = {
      preferences = {
        includePackageJsonAutoImports = "auto",
        providePrefixAndSuffixTextForCompletion = true,
      },
      suggest = {
        completeFunctionCalls = true,
        includeCompletionsForModuleExports = true,
      },
    },
  },
})
local vue_language_server_path = vim.fn.stdpath("data")
  .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
local vue_plugin = {
  name = "@vue/typescript-plugin",
  location = vue_language_server_path,
  languages = { "vue" },
  configNamespace = "typescript",
}
local tsserver_filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" }
local ts_ls_config = {
  init_options = {
    plugins = {
      vue_plugin,
    },
  },
  filetypes = tsserver_filetypes,
}
vim.lsp.config("ts_ls", ts_ls_config)
vim.lsp.config("vtsls", {
  root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
  settings = {
    vtsls = {
      autoUseWorkspaceTsdk = true,
      tsserver = {
        maxTsServerMemory = 8192,
        globalPlugins = {
          {
            name = "@vue/typescript-plugin",
            location = vim.fn.stdpath("data")
              .. "/mason/packages/vue-language-server/node_modules/@vue/typescript-plugin",
            languages = { "vue" },
            configNamespace = "typescript",
            enableForWorkspaceTypeScriptVersions = true,
          },
        },
      },
      experimental = {
        completion = {
          entriesLimit = 100,
        },
      },
    },
    typescript = {
      preferences = {
        includePackageJsonAutoImports = "auto",
        importModuleSpecifier = "non-relative",
      },
      suggest = {
        completeFunctionCalls = true,
        includeCompletionsForModuleExports = true,
        includeCompletionsWithInsertText = true,
        autoImports = true,
      },
      inlayHints = {
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = false },
        variableTypes = { enabled = false },
        propertyDeclarationTypes = { enabled = false },
        functionLikeReturnTypes = { enabled = false },
        enumMemberValues = { enabled = false },
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
  "ts_ls",
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
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
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
    javascript = { "oxfmt" },
    javascriptreact = { "oxfmt" },
    typescript = { "oxfmt" },
    typescriptreact = { "oxfmt" },
    vue = { "oxfmt" },
  },
})

local lint = require("lint")

lint.linters_by_ft = {
  -- javascript = { "oxlint", "eslint" },
  -- javascriptreact = { "oxlint", "eslint" },
  -- typescript = { "oxlint", "eslint" },
  -- typescriptreact = { "oxlint", "eslint" },
  -- vue = { "oxlint", "eslint" },
  php = { "php" },
  go = { "golangcilint" },
  c = { "clangtidy" },
  cpp = { "clangtidy" },
  -- zig = { "zlint" },
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

require("bufferline").setup({
  options = {
    mode = "buffers",
    style_preset = require("bufferline").style_preset.minimal,
    show_tab_indicators = true,
    show_close_icon = true,
    separator_style = "thin",
    always_show_bufferline = true,
    diagnostics = "nvim_lsp",
    diagnostics_indicator = function(_, _, diag)
      local icons = { Error = "✗ ", Warn = "! " }
      local ret = (diag.error and icons.Error .. diag.error .. " " or "")
        .. (diag.warning and icons.Warn .. diag.warning or "")
      return vim.trim(ret)
    end,
    offsets = {
      {
        filetype = "oil",
        text = "File Explorer",
        highlight = "Directory",
        text_align = "left",
      },
    },
  },
})
vim.keymap.set("n", "<Tab>", "<CMD>BufferLineCycleNext<CR>", { desc = "Next Buffer" })
vim.keymap.set("n", "<S-Tab>", "<CMD>BufferLineCyclePrev<CR>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<leader>1", "<CMD>BufferLineGoToBuffer 1<CR>", { desc = "Buffer 1" })
vim.keymap.set("n", "<leader>2", "<CMD>BufferLineGoToBuffer 2<CR>", { desc = "Buffer 2" })
vim.keymap.set("n", "<leader>3", "<CMD>BufferLineGoToBuffer 3<CR>", { desc = "Buffer 3" })
vim.keymap.set("n", "<leader>4", "<CMD>BufferLineGoToBuffer 4<CR>", { desc = "Buffer 4" })
vim.keymap.set("n", "<leader>5", "<CMD>BufferLineGoToBuffer 5<CR>", { desc = "Buffer 5" })
vim.keymap.set("n", "<leader>6", "<CMD>BufferLineGoToBuffer 6<CR>", { desc = "Buffer 6" })
vim.keymap.set("n", "<leader>7", "<CMD>BufferLineGoToBuffer 7<CR>", { desc = "Buffer 7" })
vim.keymap.set("n", "<leader>8", "<CMD>BufferLineGoToBuffer 8<CR>", { desc = "Buffer 8" })
vim.keymap.set("n", "<leader>9", "<CMD>BufferLineGoToBuffer 9<CR>", { desc = "Buffer 9" })

wk.add({
  { "<leader>b", group = "Buffers" },
  { "<leader>bn", "<CMD>BufferLineCycleNext<CR>", desc = "Next Buffer" },
  { "<leader>bp", "<CMD>BufferLineCyclePrev<CR>", desc = "Prev Buffer" },
  { "<leader>bc", "<CMD>bdelete<CR>", desc = "Close Buffer" },
  { "<leader>b1", "<CMD>BufferLineGoToBuffer 1<CR>", desc = "Buffer 1" },
  { "<leader>b2", "<CMD>BufferLineGoToBuffer 2<CR>", desc = "Buffer 2" },
  { "<leader>b3", "<CMD>BufferLineGoToBuffer 3<CR>", desc = "Buffer 3" },
  { "<leader>b4", "<CMD>BufferLineGoToBuffer 4<CR>", desc = "Buffer 4" },
  { "<leader>b5", "<CMD>BufferLineGoToBuffer 5<CR>", desc = "Buffer 5" },
  { "<leader>b6", "<CMD>BufferLineGoToBuffer 6<CR>", desc = "Buffer 6" },
  { "<leader>b7", "<CMD>BufferLineGoToBuffer 7<CR>", desc = "Buffer 7" },
  { "<leader>b8", "<CMD>BufferLineGoToBuffer 8<CR>", desc = "Buffer 8" },
  { "<leader>b9", "<CMD>BufferLineGoToBuffer 9<CR>", desc = "Buffer 9" },
})

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
require("nvim-treesitter.config").setup({
  install_dir = vim.fn.stdpath("data") .. "/site",
  -- ensure_installed = {
  --   "lua",
  --   "vue",
  --   "vim",
  --   "vimdoc",
  --   "query",
  --   "javascript",
  --   "typescript",
  --   "tsx",
  --   "json",
  --   "go",
  --   "python",
  --   "zig",
  --   "rust",
  --   "php",
  --   "c",
  --   "cpp",
  --   "html",
  --   "css",
  --   "sql",
  -- },
  -- sync_install = false,
  -- auto_install = true,
  -- highlight = { enable = true, additional_vim_regex_highlighting = false },
  -- indent = { enable = true },
  -- autotag = { enable = true },
})
require("nvim-treesitter").install({
  "lua",
  "vue",
  "vim",
  "vimdoc",
  "query",
  "javascript",
  "typescript",
  "tsx",
  "json",
  "go",
  "python",
  "zig",
  "rust",
  "php",
  "c",
  "cpp",
  "html",
  "css",
  "sql",
  "prisma",
})

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

require("neogen").setup({
  snippet_engine = "luasnip",
})

require("flash").setup({
  modes = {
    search = {
      enabled = true,
    },
  },
})

require("ibl").setup({
  indent = {
    char = "│",
    tab_char = "│",
    highlight = "IblIndent",
  },
  scope = {
    enabled = true,
    show_start = false,
    show_end = false,
    highlight = "IblScope",
  },
})

require("todo-comments").setup({
  keywords = {
    FIX = {
      icon = " ",
      color = "error",
      alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
    },
    TODO = { icon = "✓ ", color = "info" },
    HACK = { icon = " ", color = "warning" },
    WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
    PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
    NOTE = { icon = "󰍨 ", color = "hint", alt = { "INFO" } },
  },
})

require("noice").setup({
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
    progress = {
      enabled = true,
    },
    signature = {
      enabled = true,
    },
    message = {
      enabled = true,
    },
  },
  presets = {
    bottom_search = true,
    command_palette = true,
    long_message_to_split = true,
    inc_rename = false,
    lsp_doc_border = false,
  },
})

wk.add({
  { "<leader>n", group = "Neogen" },
  {
    "<leader>ng",
    function()
      require("neogen").generate()
    end,
    desc = "Generate Docstring",
  },
  {
    "<leader>nf",
    function()
      require("neogen").generate({ type = "func" })
    end,
    desc = "Generate Function Docstring",
  },
  {
    "<leader>nt",
    function()
      require("neogen").generate({ type = "type" })
    end,
    desc = "Generate Type Docstring",
  },
})

wk.add({
  { "<leader>t", group = "Todo" },
  {
    "<leader>tt",
    function()
      require("fzf-lua").todo()
    end,
    desc = "Find Todos",
  },
  {
    "<leader>tf",
    function()
      require("todo-comments").fzf()
    end,
    desc = "Find Todos (todo-comments)",
  },
})

vim.keymap.set("n", "s", "<cmd>Flash<cr>", { desc = "Flash Jump" })
vim.keymap.set("x", "s", "<cmd>Flash<cr>", { desc = "Flash Jump" })
