local plugins = {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "ninja", "python", "rst", "toml" })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        pyright = {},
        ruff_lsp = {},
      },
      setup = {
        ruff_lsp = function()
          require("lazyvim.util").lsp.on_attach(function(client, _)
            if client.name == "ruff_lsp" then
              -- Disable hover in favor of Pyright
              client.server_capabilities.hoverProvider = false
            end
          end)
        end,
      },
    },
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    dependencies = {
      {
        "williamboman/mason.nvim",
        optional = true,
        opts = function(_, opts)
          vim.list_extend(opts.ensure_installed, { "black" })
        end,
      },
    },
    opts = {
      formatters_by_ft = {
        python = { "black" },
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    dependencies = {
      {
        "williamboman/mason.nvim",
        optional = true,
        opts = function(_, opts)
          vim.list_extend(opts.ensure_installed, { "pylint" })
        end,
      },
    },
    opts = {
      linters_by_ft = {
        python = { "pylint" },
      },
    },
  },
}

return plugins
