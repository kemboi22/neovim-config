return {
  -- Contains such as comments
  {
    "folke/ts-comments.nvim",
    opts = {},
    event = "VeryLazy",
    enabled = vim.fn.has "nvim-0.10.0" == 1,
  },
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    dependencies = { "nvim-treesitter/nvim-treesitter" }, -- Ensure treesitter is installed
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
}
