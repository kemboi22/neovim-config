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
        { import = "lazyvim.plugins.extras.lang.php" },  -- PHP plugin
        { import = "lazyvim.plugins.extras.lang.go" },   -- Go plugin
        {  import = "lazyvim.plugins.extras.lang.tailwind" },
        { import = "lazyvim.plugins.extras.linting.eslint" },
        { import = "lazyvim.plugins.extras.lang.omnisharp" },

      },
    },
  },
  require "utils.lang-php",
  require("utils.lang-go"),
  require("utils.ui")
  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
