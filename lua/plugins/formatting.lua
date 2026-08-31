local util = require("config.util")
local conform = require("conform")

local oxfmt_configs = {
  ".oxfmtrc.json",
  ".oxfmtrc.jsonc",
  "oxfmt.config.ts",
  "oxfmt.config.mts",
  "oxfmt.config.cts",
  "oxfmt.config.js",
  "oxfmt.config.mjs",
  "oxfmt.config.cjs",
}

local sql_configs = { ".sqlfluff", "pyproject.toml", "setup.cfg", "tox.ini", "pep8.ini" }

conform.setup({
  notify_on_error = true,
  notify_no_formatters = false,
  formatters_by_ft = {
    lua = { "stylua" },
    c = { "clang_format" },
    cpp = { "clang_format" },
    blade = { "blade-formatter" },
    zig = { "zigfmt" },
    rust = { "rustfmt" },
    odin = { "odinfmt" },
    go = { "goimports", "gofmt" },
    php = { "php_cs_fixer" },
    sh = { "shfmt" },
    bash = { "shfmt" },
    javascript = { "oxfmt" },
    javascriptreact = { "oxfmt" },
    typescript = { "oxfmt" },
    typescriptreact = { "oxfmt" },
    vue = { "oxfmt" },
    svelte = { "oxfmt" },
    json = { "oxfmt" },
    jsonc = { "oxfmt" },
    css = { "oxfmt" },
    scss = { "oxfmt" },
    less = { "oxfmt" },
    html = { "oxfmt" },
    markdown = { "oxfmt" },
    yaml = { "oxfmt" },
    toml = { "oxfmt" },
    sql = { "sqlfluff" },
    mysql = { "sqlfluff" },
    plsql = { "sqlfluff" },
  },
  formatters = {
    oxfmt = {
      prepend_args = function(_, ctx)
        if vim.bo[ctx.buf].filetype ~= "svelte" or util.find_upward(oxfmt_configs, ctx.dirname) then
          return {}
        end
        return { "--config=" .. vim.fn.stdpath("config") .. "/configs/oxfmt.json" }
      end,
    },
    sqlfluff = {
      args = function(_, ctx)
        local args = { "format" }
        if not util.find_upward(sql_configs, ctx.dirname) then
          vim.list_extend(args, { "--dialect", "ansi" })
        end
        table.insert(args, "-")
        return args
      end,
      cwd = function(_, ctx)
        local config = util.find_upward(sql_configs, ctx.dirname)
        return config and vim.fs.dirname(config) or ctx.dirname
      end,
      require_cwd = false,
    },
    php_cs_fixer = {
      prepend_args = function(_, ctx)
        local config = util.find_upward({ ".php-cs-fixer.php", ".php-cs-fixer.dist.php" }, ctx.dirname)
          or (vim.fn.stdpath("config") .. "/configs/.php-cs-fixer.php")
        return { "--config=" .. config }
      end,
    },
  },
  format_on_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat or util.is_big_file(bufnr) then
      return
    end
    return { timeout_ms = 2000, lsp_format = "fallback" }
  end,
})

vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    vim.g.disable_autoformat = true
  else
    vim.b.disable_autoformat = true
  end
end, { desc = "Disable format on save", bang = true })

vim.api.nvim_create_user_command("FormatEnable", function(args)
  if args.bang then
    vim.g.disable_autoformat = false
  else
    vim.b.disable_autoformat = false
  end
end, { desc = "Enable format on save", bang = true })

local lint = require("lint")
local base_sqlfluff = lint.linters.sqlfluff

lint.linters.sqlfluff = function()
  local config = vim.deepcopy(base_sqlfluff)
  config.args = { "lint", "--format=json" }
  if not util.find_upward(sql_configs) then
    vim.list_extend(config.args, { "--dialect", "ansi" })
  end
  table.insert(config.args, "-")
  return config
end

lint.linters_by_ft = {
  php = { "php" },
  go = { "golangcilint" },
  c = { "clangtidy" },
  cpp = { "clangtidy" },
  sql = { "sqlfluff" },
  mysql = { "sqlfluff" },
  plsql = { "sqlfluff" },
}

local lint_group = vim.api.nvim_create_augroup("config_lint", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
  group = lint_group,
  callback = function(args)
    if not util.is_big_file(args.buf) then
      require("lint").try_lint()
    end
  end,
})
