return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      spec = {
        -- Add the LazyVim PHP extras here
        { import = "lazyvim.plugins.extras.lang.php", enabled = true }, -- PHP plugin
        { import = "lazyvim.plugins.extras.lang.go", enabled = true }, -- Go plugin
        { import = "lazyvim.plugins.extras.lang.tailwind", enabled = true },
        { import = "lazyvim.plugins.extras.linting.eslint", enabled = true },
        { import = "lazyvim.plugins.extras.lang.omnisharp", enabled = true },
        { import = "lazyvim.plugins.extras.lang.python", enabled = true },
      },
    },
  },
  {
    "williamboman/mason.nvim",

    opts = {
      ensure_installed = {
        "shfmt",
        "shellcheck",
        "php-cs-fixer",
        "phpactor",
        "intelephense",
        "prettierd",
        "xmlformatter",
        "isort",
        "black",
        "pylint",
        "ruff",
        "mypy",
        "pylsp",
        "pyright",
        "jdtls",
      },
    },
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
        "vue",
        "typescript",
        "javascript",
        "bash",
        "php",
        "go",
        "java",
      },
    },
  },
  require "utils.lang-php",
  require "utils.lang-go",
  require "utils.ui",
  require "utils.lang-web",

  require "tools.snacks",
  require "tools.ui",
  require "tools.tools",
  require "tools.lint",
}
