local lazyUtils = require "custom.utils.lazy"

return {
  {
    "ThePrimeagen/refactoring.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      {
        "<leader>r",
        "",
        desc = "refactor",
        mode = { "n", "v" },
      },

      {
        "<leader>rs",
        function()
          return require("telescope").extensions.refactoring.refactors()
        end,
        mode = "v",
        desc = "Refactor",
      },
      {
        "<leader>ri",
        function()
          require("refactoring").refactor "Inline Variable"
        end,
        mode = { "n", "v" },
        desc = "Inline Variable",
      },
      {
        "<leader>rb",
        function()
          require("refactoring").refactor "Extract Block"
        end,
        desc = "Extract Block",
      },
      {
        "<leader>rf",
        function()
          require("refactoring").refactor "Extract Block To File"
        end,
        desc = "Extract Block To File",
      },
      {
        "<leader>rP",
        function()
          require("refactoring").debug.printf { below = false }
        end,
        desc = "Debug Print",
      },
      {
        "<leader>rp",
        function()
          require("refactoring").debug.print_var { normal = true }
        end,
        desc = "Debug Print Variable",
      },
      {
        "<leader>rc",
        function()
          require("refactoring").debug.cleanup {}
        end,
        desc = "Debug Cleanup",
      },
      {
        "<leader>rf",
        function()
          require("refactoring").refactor "Extract Function"
        end,
        mode = "v",
        desc = "Extract Function",
      },
      {
        "<leader>rF",
        function()
          require("refactoring").refactor "Extract Function To File"
        end,
        mode = "v",
        desc = "Extract Function To File",
      },
      {
        "<leader>rx",
        function()
          require("refactoring").refactor "Extract Variable"
        end,
        mode = "v",
        desc = "Extract Variable",
      },
      {
        "<leader>rp",
        function()
          require("refactoring").debug.print_var()
        end,
        mode = "v",
        desc = "Debug Print Variable",
      },
    },
    opts = {
      prompt_func_return_type = {
        go = false,
        java = false,
        cpp = false,
        c = false,
        h = false,
        hpp = false,
        cxx = false,
      },
      prompt_func_param_type = {
        go = false,
        java = false,
        cpp = false,
        c = false,
        h = false,
        hpp = false,
        cxx = false,
      },
      printf_statements = {},
      print_var_statements = {},
      show_success_message = true, -- shows a message with information about the refactor on success
      -- i.e. [Refactor] Inlined 3 variable occurrences
    },
    config = function(_, opts)
      require("refactoring").setup(opts)
      lazyUtils.on_load("telescope.nvim", function()
        require("telescope").load_extension "refactoring"
      end)
    end,
  },
  {
    "danymat/neogen",
    config = function()
      require("neogen").setup {
        enabled = true, -- Enable Neogen
        languages = {
          php = {
            template = {
              annotation_convention = "phpdoc", -- Use PHPDoc as the standard
            },
          },
          -- Add other languages if needed
        },
      }

      -- Optional: Keybinding for generating comments
      vim.keymap.set("n", "<leader>nc", ":Neogen<CR>", { silent = true, noremap = true, desc = "Generate Doc Comment" })
    end,
    cmd = { "Neogen" }, -- Lazy-load the plugin when `:Neogen` is called
  },
}
