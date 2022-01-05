local present, ts_config = pcall(require, "nvim-treesitter.configs")

if not present then
   return
end

ts_config.setup {
   textsubjects = {
      enable = true,
      keymaps = {
         ["."] = "textsubjects-smart",
         [";"] = "textsubjects-container-outer",
      },
   },
   matchup = {
      enable = true,
   },
   autopairs = {
      enable = true,
   },
   autotag = {
      enable = true,
   },
   context_commentstring = {
      enable = true,
      enable_autocmd = false,
   },
   ensure_installed = {
      "bash",
      "css",
      "graphql",
      "html",
      "javascript",
      "json",
      "lua",
      "markdown",
      "nix",
      "python",
      "svelte",
      "toml",
      "typescript",
      "vim",
   },
   highlight = {
      enable = true,
      use_languagetree = true,
      additional_vim_regex_highlighting = {},
   },
   incremental_selection = {
      enable = true,
   },
}
