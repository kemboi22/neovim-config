return {
  {
    "adalessa/laravel.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "tpope/vim-dotenv",
      "MunifTanjim/nui.nvim",
      "nvimtools/none-ls.nvim",
    },
    cmd = { "Sail", "Artisan", "Composer", "Npm", "Yarn", "Laravel" },
    keys = {
      { "<leader>la", ":Laravel artisan<cr>" },
      { "<leader>lr", ":Laravel routes<cr>" },
      { "<leader>lm", ":Laravel related<cr>" },
    },
    event = { "VeryLazy" },
    opts = {
      lsp_server = "phpactor",
      features = {
        null_ls = {
          enable = false,
        },
        route_info = {
          enable = true, --- to enable the laravel.nvim virtual text
          position = "right", --- where to show the info (available options 'right', 'top')
          middlewares = true, --- wheather to show the middlewares section in the info
          method = true, --- wheather to show the method section in the info
          uri = true, --- wheather to show the uri section in the info
        },
      },
    },
    config = true,
  },
  {
    "ricardoramirezr/blade-nav.nvim",
    requires = {
      "hrsh7th/nvim-cmp", -- if using nvim-cmp
      { "ms-jpq/coq_nvim", branch = "coq" }, -- if using coq
    },
    ft = { "blade", "php" }, -- optional, improves startup time
    opts = {
      close_tag_on_complete = true, -- default: true
    },
  },
  {

    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = opts.sources or {}
      table.insert(
        opts.sources,
        nls.builtins.formatting.phpcsfixer.with({
          extra_args = {
            "--rules=@PSR12",
            "--using-cache=no",
          },
        })
      )
      table.insert(
        opts.sources,
        nls.builtins.formatting.prettier.with({
          filetypes = { "blade" },
        })
      )
    end,
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        php = { "phpcs" },
      },
      linters = {
        phpcs = {
          args = {
            "--standard=PSR12",
            "--report=json",
            "-q",
            "--runtime-set",
            "ignore_warnings_on_exit",
            "1",
          },
        },
        phpstan = {
          args = {
            "analyze",
            "--error-format",
            "raw",
            "--no-progress",
            "--level",
            "5",
          },
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Configure PHP LSP (Intelliphense)
        intelephense = {
          init_options = {
            licenceKey = nil, -- Set your license key if you have one
          },
          settings = {
            intelephense = {
              environment = {
                phpVersion = "8.2", -- Adjust based on your PHP version
              },
              files = {
                maxSize = 5000000,
              },
              format = {
                enable = true,
              },
              stubs = {
                "apache",
                "bcmath",
                "bz2",
                "calendar",
                "com_dotnet",
                "Core",
                "curl",
                "date",
                "dba",
                "dom",
                "enchant",
                "exif",
                "fileinfo",
                "filter",
                "fpm",
                "ftp",
                "gd",
                "gettext",
                "gmp",
                "hash",
                "iconv",
                "imap",
                "intl",
                "json",
                "ldap",
                "libxml",
                "mbstring",
                "mcrypt",
                "mysql",
                "mysqli",
                "oci8",
                "openssl",
                "pcntl",
                "pcre",
                "PDO",
                "pdo_mysql",
                "Phar",
                "readline",
                "recode",
                "Reflection",
                "regex",
                "session",
                "shmop",
                "SimpleXML",
                "soap",
                "sockets",
                "sodium",
                "SPL",
                "standard",
                "superglobals",
                "sysvmsg",
                "sysvsem",
                "sysvshm",
                "tidy",
                "tokenizer",
                "xml",
                "xmlreader",
                "xmlrpc",
                "xmlwriter",
                "xsl",
                "Zend OPcache",
                "zip",
                "zlib",
                "wordpress",
                "phpunit",
                "laravel",
              },
            },
          },
        },
        -- Configure Phpactor as alternative
        phpactor = {
          cmd = { "phpactor", "language-server" },
          filetypes = { "php" },
          root_dir = require("lspconfig.util").root_pattern("composer.json", ".git"),
          init_options = {
            ["language_server_phpstan.enabled"] = true,
            ["language_server_psalm.enabled"] = true,
          },
        },
      },
    },
  },
  {
    "Zeioth/dooku.nvim",
    event = "VeryLazy",
    opts = {
      -- your config options here
    },
  },
}
