return {
  {
    "adalessa/laravel.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "tpope/vim-dotenv",
      "MunifTanjim/nui.nvim",
      "nvimtools/none-ls.nvim",
      "nvim-neotest/nvim-nio",
    },
    cmd = { "Sail", "Artisan", "Composer", "Npm", "Yarn", "Laravel" },
    keys = {
      { "<leader>la", ":Laravel artisan<cr>" },
      { "<leader>lr", ":Laravel routes<cr>" },
      { "<leader>lm", ":Laravel related<cr>" },
    },
    event = { "VeryLazy" },
    opts = {
      lsp_server = "intelephense",
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
        pickers = {
          provider = "snacks",
        },
      },
      extensions = {
        completion = { enable = true },
        composer_dev = { enable = true },
        composer_info = { enable = true },
        diagnostic = { enable = true },
        dump_server = { enable = true },
        model_info = { enable = true },
        override = { enable = true },
        tinker = { enable = true },
        command_center = { enable = true },
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
          prefer_local = "vendor/bin",
          extra_args = {
            -- First tries project's .php-cs-fixer.php
            -- Falls back to global config if not found
            "--config=" .. vim.fn.expand("~/.config/php-cs-fixer/.php-cs-fixer.php"),
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
        -- phpcs = {
        --   args = {
        --     "--standard=PSR12",
        --     "--report=json",
        --     "-q",
        --     "--runtime-set",
        --     "ignore_warnings_on_exit",
        --     "1",
        --     "--runtime-set",
        --     "ignore_errors_on_exit",
        --     "1",
        --     "-s", -- Show sniff codes
        --   },
        -- },
        -- phpstan = {
        --   args = {
        --     "analyze",
        --     "--error-format=json",
        --     "--no-progress",
        --     "--level=8", -- Increased to level 8 for stricter analysis
        --     "--memory-limit=2G",
        --   },
        -- },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Configure PHP LSP (Intelliphense)
        intelephense = {

          settings = {
            intelephense = {
              environment = {
                phpVersion = "8.5", -- Adjust based on your PHP version
              },
              completion = {
                insertUseDeclaration = true,
                fullyQualifyGlobalConstantsAndFunctions = true,
                triggerParameterHints = true,
                maxItems = 100,
              },
              enable = true,
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
                "random",
                "laravel",
                "phpunit",
              },
              diagnostics = {
                enable = true,
                run = "onType",
                embeddedLanguages = true,
                undefinedVariables = true,
                undefinedTypes = true,
                undefinedFunctions = true,
                undefinedConstants = true,
                undefinedClassConstants = true,
                undefinedMethods = true,
                undefinedProperties = true,
                deprecations = true,
                unusedSymbols = true,
                implementationErrors = true,
                typeErrors = true,
                duplicateSymbols = true,
                argumentCount = true,
              },
              phpdoc = {
                returnVoid = true,
                textFormat = "snippet",
                classTemplate = {
                  summary = "$1",
                  description = "$2",
                  tags = {
                    "package ${1:$SYMBOL_NAMESPACE}",
                    "author ${2:Your Name}",
                  },
                },
                propertyTemplate = {
                  summary = "$1",
                  description = "$2",
                  tags = {
                    "var ${1:$SYMBOL_TYPE}",
                  },
                },
                functionTemplate = {
                  summary = "$1",
                  description = "$2",
                  tags = {
                    "@param ${1:$SYMBOL_TYPE} $${2:$SYMBOL_NAME} $3",
                    "@return ${1:$SYMBOL_TYPE} $2",
                    "@throws ${1:Exception} $2",
                  },
                },
              },
              telemetry = {
                enabled = false,
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
  {
    "kkoomen/vim-doge",
  },
}
