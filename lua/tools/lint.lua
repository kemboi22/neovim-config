return {
  "mfussenegger/nvim-lint",
  optional = true,
  opts = {
    events = { "BufWritePost", "BufReadPost", "InsertLeave" },
    linters_by_ft = {
      php = { "phpcs", "phpstan", "phpmd" },
      go = { "golangcilint" },
       sh = { "shellcheck" },
      python = { "pylint" },

    },
  },
}
