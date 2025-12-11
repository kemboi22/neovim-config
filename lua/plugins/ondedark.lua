return {
  {
    "olimorris/onedarkpro.nvim",
    priority = 1000,
    config = function()
      require("onedarkpro").setup({
        options = {
          transparency = false,
        },
      })
    end,
  },
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("neogen").setup({
        enabled = true,
        snippet_engine = "luasnip", -- or "nvim-snippet" or "snippy"
        languages = {
          php = {
            template = {
              annotation_convention = "phpdoc",
            },
          },
          typescript = {
            template = {
              annotation_convention = "tsdoc", -- or "jsdoc"
            },
          },
          javascript = {
            template = {
              annotation_convention = "jsdoc",
            },
          },
          go = {
            template = {
              annotation_convention = "godoc",
            },
          },
          rust = {
            template = {
              annotation_convention = "rustdoc", -- or "numpydoc"
            },
          },
          c = {
            template = {
              annotation_convention = "doxygen", -- or "kernel_doc"
            },
          },
          cpp = {
            template = {
              annotation_convention = "doxygen",
            },
          },
          zig = {
            template = {
              annotation_convention = "zigdoc",
            },
          },
          python = {
            template = {
              annotation_convention = "numpydoc", -- or "google_docstrings", "reST"
            },
          },
          lua = {
            template = {
              annotation_convention = "ldoc", -- or "emmylua"
            },
          },
        },
      })

      -- Keymaps
      vim.keymap.set("n", "<leader>pd", ":Neogen<CR>", { desc = "Generate Docblock" })
      vim.keymap.set("n", "<leader>pf", ":Neogen func<CR>", { desc = "Generate Function Doc" })
      vim.keymap.set("n", "<leader>pc", ":Neogen class<CR>", { desc = "Generate Class Doc" })
      vim.keymap.set("n", "<leader>pt", ":Neogen type<CR>", { desc = "Generate Type Doc" })
    end,
  },
}
