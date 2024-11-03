return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    -- event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
    config = function()
      local conform = require "conform"

      conform.setup {
        formatters_by_ft = {
          lua = { "stylua" },
          python = { { "isort", "black" } },
          javascript = { "prettierd" },
          typescript = { "prettierd" },
          css = { "prettierd" },
          html = { "prettierd" },
          json = { "prettierd" },
          yaml = { "prettierd" },
          markdown = { "prettierd" },
          vue = { "prettierd" },
          php = {{"php-cs-fixer", "pint" }}
        },
        format_on_save = {
          lsp_fallback = true,
          async = false,
          timeout_ms = 500,
        },
        formatters = {
          ["php-cs-fixer"] = {
            command = "php-cs-fixer",
            args = {
              "fix",
              "--rules=@PSR12",
              "$FILENAME"
            },
            stdin = false
          },
        },
        notify_on_error = true,
        stop_after_first = true
      }
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "typescript-language-server",
        "bash-language-server",
        "css-lsp",
        "docker-compose-language-service",
        "dockerfile-language-server",
        "eslint-lsp",
        "go-debug-adapter",
        "gofumpt",
        "goimports",
        "goimports-reviser",
        "golangci-lint",
        "golangci-lint-langserver",
        "golines",
        "gomodifytags",
        "gopls",
        "html-lsp",
        "lua-language-server",
        "pest-language-server",
        "php-cs-fixer",
        "phpactor",
        "phpcbf",
        "phpcs",
        "phpstan",
        "pint",
        "prettierd",
        "pretty-php",
        "stylua",
        "tailwindcss-language-server",
        "vue-language-server",
        "yaml-language-server",
        "intelephense",
        "python-lsp-server",
        "pylint",
        "stylua",
        "black",
        "isort",
        "eslint_d",
      },
      automatic_installation = true,
    },
    config = function()
      require("mason").setup()
    end,
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    event = "VeryLazy",
    opts = function()
      return require "custom.configs.null-ls"
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    ft = {
      "javascript",
      "typescript",
      "html",
      "vue",
    },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "javascript",
        "typescript",
        "vue",
        "php",
        "bash",
        "json",
        "dot",
        "go",
        "gitcommit",
        "gitignore",
        "gomod",
        "goctl",
        "phpdoc",
        "python",
        "dockerfile",
        "comment",
      },
    },
  },
  {
    "adalessa/laravel.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "tpope/vim-dotenv",
      "MunifTanjim/nui.nvim",
      "nvimtools/none-ls.nvim",
    },
    cmd = { "Sail", "Artisan", "Composer", "Npm", "Yarn", "Laravel" },
    keys = {
      { "<leader>la", ":Laravel artisan<cr>" },
      { "<leader>lr", ":Laravel routes<cr>" },
      { "<leader>lm", ":Laravel related<cr>" },
    },
    event = { "VeryLazy" },
    opts = {
      lsp_server = "intelephense",
      features = {
        null_ls = {
          enable = true,
        },
        route_info = {
          enable = true, --- to enable the laravel.nvim virtual text
          position = "right", --- where to show the info (available options 'right', 'top')
          middlewares = true, --- wheather to show the middlewares section in the info
          method = true, --- wheather to show the method section in the info
          uri = true, --- wheather to show the uri section in the info
        },
      },
    },
    config = true,
  },
  {
    "rcarriga/nvim-notify",
    config = function()
      local notify = require "notify"
      -- this for transparency
      notify.setup { background_colour = "#000000" }
      -- this overwrites the vim notify function
      vim.notify = notify.notify
    end,
  },
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()',
  },
  {
    "dariuscorvus/tree-sitter-surrealdb.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      -- setup step
      require("tree-sitter-surrealdb").setup()
    end,
  },
  {
    "mfussenegger/nvim-lint",
    event = {
      "BufReadPre",
      "BufNewFile",
    },
    config = function()
      local lint = require "lint"

      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        python = { "pylint" },
        vue = { "eslint_d" },
        go = { "golangcilint" },
        php = { "phpcs" },
      }

      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })

      vim.keymap.set("n", "<leader>ll", function ()
        lint.try_lint()        
      end, { desc = "Trigger linting for current file" })
    end,
  },
  {
    'kristijanhusak/vim-dadbod-ui',
  dependencies = {
    { 'tpope/vim-dadbod', lazy = true },
    { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
  },
  cmd = {
    'DBUI',
    'DBUIToggle',
    'DBUIAddConnection',
    'DBUIFindBuffer',
  },
  init = function()
    -- Your DBUI configuration
    vim.g.db_ui_use_nerd_fonts = 1
  end,
  },
  {
    -- Add the blade-nav.nvim plugin which provides Goto File capabilities
    -- for Blade files.
    "ricardoramirezr/blade-nav.nvim",
    dependencies = {
      "hrsh7th/nvim-cmp",
    },
    ft = { "blade", "php" },
  },
   }
