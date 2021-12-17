-- This is where your custom modules and plugins go.
-- See the wiki for a guide on how to extend NvChad

local hooks = require "core.hooks"

-- NOTE: To use this, make a copy with `cp example_init.lua init.lua`

--------------------------------------------------------------------

-- To modify packaged plugin configs, use the overrides functionality
-- if the override does not exist in the plugin config, make or request a PR,
-- or you can override the whole plugin config with 'chadrc' -> M.plugins.default_plugin_config_replace{}
-- this will run your config instead of the NvChad config for the given plugin

-- hooks.override("lsp", "publish_diagnostics", function(current)
--   current.virtual_text = false;
--   return current;
-- end)

-- To add new mappings, use the "setup_mappings" hook,
-- you can set one or many mappings
-- example below:

-- hooks.add("setup_mappings", function(map)
--    map("n", "<leader>cc", "gg0vG$d", opt) -- example to delete the buffer
--    .... many more mappings ....
-- end)
hooks.add("setup_mappings", function(map)
   local opts = { noremap = true, silent = true }

   -- for null-ls
   map("n", "<space>fm", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end)

-- To add new plugins, use the "install_plugin" hook,
-- NOTE: we heavily suggest using Packer's lazy loading (with the 'event' field)
-- see: https://github.com/wbthomason/packer.nvim
-- examples below:

-- hooks.add("install_plugins", function(use)
--    use {
--       "max397574/better-escape.nvim",
--       event = "InsertEnter",
--    }
-- end)
hooks.add("install_plugins", function(use)
   use {
      "tversteeg/registers.nvim",
      config = function()
         -- TODO: update bg here?
      end,
   }

   use {
      "jose-elias-alvarez/null-ls.nvim",
      after = "nvim-lspconfig",
      config = function()
         require("custom.plugin_confs.null-ls").setup()
      end,
   }

   use {
      "dsznajder/vscode-es7-javascript-react-snippets",
      event = "InsertEnter",
   }

   use {
      "folke/todo-comments.nvim",
      requires = "nvim-lua/plenary.nvim",
      config = function()
         require("custom.plugin_confs.todo-comments").setup()
      end
   }

   use { 
      'TimUntersberger/neogit', 
      requires = { 
        'nvim-lua/plenary.nvim',
        'sindrets/diffview.nvim',
      },
      config = function()
         require("custom.plugin_confs.neogit").setup()
      end
    }

   use {
      "sindrets/diffview.nvim",
      requires = 'nvim-lua/plenary.nvim',
   }

   use 'ThePrimeagen/vim-be-good'

   -- use "dstein64/nvim-scrollview"
end)

-- alternatively, put this in a sub-folder like "lua/custom/plugins/mkdir"
-- then source it with

-- require "custom.plugins.mkdir"
