local constants = require "custom.utils.constants"

return {
  {
    enabled = not constants.first_install,
    import = "lazyvim.plugins.extras.lang.python",
  },

  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        ruff_lsp = {
          keys = {
            {
              "<leader>co",
              false,
            },
            {
              "<leader>lo",
              function()
                vim.lsp.buf.code_action {
                  apply = true,
                  context = {
                    only = { "source.organizeImports" },
                    diagnostics = {},
                  },
                }
              end,
              desc = "Organize Imports",
            },
          },
        },
        pylsp = {

        },
        pyright = {
          filetypes = { "python" }
        }
      },
    },
  },

  -- undo none-ls changes added by LazyVim
  {
    "nvimtools/none-ls.nvim",
    enabled = true,
    opts = {
      diagnostics = {
        python = { "ruff", "mypy" }
      },
      formatters_by_ft = {
        python = { "black" }
      }
    }
  },

  {
    "mfussenegger/nvim-lint",
    dependencies = {
      {
        "williamboman/mason.nvim",
        optional = true,
        opts = {
          ensure_installed = { "pylint" },
        },
      },
    },
    opts = {
      linters_by_ft = {
        python = { "pylint" },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        python = { "isort", "black" }
      }
    }
  }
}
