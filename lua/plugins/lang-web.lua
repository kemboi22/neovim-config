return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },
  {
    "yioneko/nvim-vtsls",
    ft = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("vtsls").config({})
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {
          filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
          settings = {
            vtsls = {
              tsserver = {
                maxTsServerMemory = 8192,
                globalPlugins = {
                  {
                    name = "@vue/typescript-plugin",
                    location = vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/typescript-plugin",
                    languages = { "vue" },
                    configNamespace = "typescript",
                    enableForWorkspaceTypeScriptVersions = true,
                  },
                },
              },
              experimental = {
                completion = {
                  entriesLimit = 100,
                },
              },
            },
            typescript = {
              preferences = {
                includePackageJsonAutoImports = "auto",
                importModuleSpecifier = "relative",
              },
              suggest = {
                completeFunctionCalls = true,
                includeCompletionsForModuleExports = true,
                includeCompletionsWithInsertText = true,
                autoImports = true,
              },
              inlayHints = {
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = false },
                variableTypes = { enabled = false },
                propertyDeclarationTypes = { enabled = false },
                functionLikeReturnTypes = { enabled = false },
                enumMemberValues = { enabled = false },
              },
            },
          },
        },
        volar = {
          filetypes = { "vue" },
          init_options = {
            vue = {
              hybridMode = true,
            },
          },
          settings = {
            typescript = {
              preferences = {
                includePackageJsonAutoImports = "auto",
                providePrefixAndSuffixTextForCompletion = true,
              },
              suggest = {
                completeFunctionCalls = true,
                includeCompletionsForModuleExports = true,
              },
            },
          },
        },
      },
    },
  },
}
