return {
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup({
        lsp_cfg = {
          settings = {
            gopls = {
              usePlaceholders = false,
              analyses = {
                fillstruct = false,
              },
            },
          },
        },
        lsp_inlay_hints = {
          enable = false,
        },
        luasnip = false,
      })
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()',
  },
}
