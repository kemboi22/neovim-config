

return {
  
  -- {
  --   "williamboman/mason.nvim",
  --   optional = true,
  --   opts = function(_, opts)
  --     ensure_installed = {
  --       "go-debug-adapter",
  --       "gofumpt",
  --       "goimports",
  --       "goimports-reviser",
  --       "golangci-lint",
  --       "golangci-lint-langserver",
  --       "golines",
  --       "gomodifytags",
  --       "gopls",
  --     }
  --
  --     opts.ensure_installed = opts.ensure_installed or {}
  --   end,
  -- },
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
    "mfussenegger/nvim-lint",
    event = {
      "BufReadPre",
      "BufNewFile",
    },
    config = function()
      local lint = require "lint"

      lint.linters_by_ft = {
        go = { "golangcilint" },
      }
    end,
  },
  -- {
  --   "stevearc/conform.nvim",
  --   optional = true,
  --   opts = {
  --     formatters_by_ft = {
  --       go = { "goimports_reviser", "gofumpt", "golines" },
  --     },
  --   },
  -- },
  {
    "echasnovski/mini.icons",
    opts = {
      file = {
        [".go-version"] = { glyph = "", hl = "MiniIconsBlue" },
      },
      filetype = {
        gotmpl = { glyph = "󰟓", hl = "MiniIconsGrey" },
      },
    },
  },
}
