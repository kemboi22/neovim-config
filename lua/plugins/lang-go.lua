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
                fillstruct = true,
              },
            },
          },
        },
        lsp_inlay_hints = {
          enable = true,
        },
        luasnip = false,
      })
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()',
  },
}
