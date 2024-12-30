-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = { "html", "astro", "cssmodules_ls", "svelte", "tailwindcss" }
local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end
lspconfig.cssls.setup {
  on_init = nvlsp.on_init,
  on_attach = nvlsp.on_attach,
  capabilities = vim.tbl_extend("keep", {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = true,
        },
      },
    },
  }, nvlsp.capabilities),
  init_options = {
    provideFormatter = false,
  },
  settings = {
    css = {
      validate = true,
    },
    less = {
      validate = true,
    },
    scss = {
      validate = true,
    },
  },
  options = {}, -- Add additional options here if needed
}
lspconfig.gopls.setup {
  on_init = nvlsp.on_init,
  on_attach = nvlsp.on_attach,
  capabilities = nvlsp.capabilities,
  settings = {
    gopls = {
      gofumpt = true,
      codelenses = {
        gc_details = false,
        generate = true,
        regenerate_cgo = true,
        run_govulncheck = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      analyses = {
        fieldalignment = true,
        nilness = true,
        unusedparams = true,
        unusedwrite = true,
        useany = true,
      },
      usePlaceholders = true,
      completeUnimported = true,
      staticcheck = true,
      directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
      semanticTokens = true,
    },
  },
  options = {},
}

lspconfig.phpactor.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
}
local mason_registery = require "mason-registry"
local vue_ls_path = mason_registery.get_package("vue-language-server"):get_install_path()
  .. "/node_modules/@vue/language-server"
lspconfig.vtsls.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "vue",
  },
  keys = {
    {
      "go",
      function()
        require("vtsls").commands.goto_source_definition(0)
      end,
      desc = "Goto Source Definition",
    },
    {
      "gR",
      function()
        require("vtsls").commands.file_references(0)
      end,
      desc = "File References",
    },
    {
      "<leader>lo",
      function()
        require("vtsls").commands.organize_imports(0)
      end,
      desc = "Organize Imports",
    },
    {
      "<leader>lm",
      function()
        require("vtsls").commands.add_missing_imports(0)
      end,
      desc = "Add missing imports",
    },
    {
      "<leader>lu",
      function()
        require("vtsls").commands.remove_unused_imports(0)
      end,
      desc = "Remove unused imports",
    },
    {
      "<leader>lD",
      function()
        require("vtsls").commands.fix_all(0)
      end,
      desc = "Fix all diagnostics",
    },
    {
      "<leader>lT",
      function()
        require("vtsls").commands.select_ts_version(0)
      end,
      desc = "Select TS workspace version",
    },
  },
  settings = {
    complete_function_calls = true,
    vtsls = {
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
      experimental = {
        completion = {
          enableServerSideFuzzyMatch = true,
        },
      },
      tsserver = {
        globalPlugins = {
          {
            name = "@vue/typescript-plugin",
            location = vue_ls_path,
            languages = { "vue" },
            configNamespace = "typescript",
            enableForWorkspaceTypeScriptVersions = true,
          },
        },
      },
    },
    typescript = {
      format = {
        indentSize = vim.o.shiftwidth,
        convertTabsToSpaces = vim.o.expandtab,
        tabSize = vim.o.tabstop,
        lineWidth = 120,
      },
      preferences = { importModuleSpecifier = "non-relative" },
      updateImportsOnFileMove = { enabled = "always" },
      suggest = { completeFunctionCalls = true },
      inlayHints = {
        enumMemberValues = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        parameterNames = { enabled = "all" },
        parameterTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        variableTypes = { enabled = true },
      },
    },
  },
}
lspconfig.emmet_language_server.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  filetypes = {
    "astro",
    "css",
    "eruby",
    "html",
    "xhtml",
    "xml",
    "htmldjango",
    "javascriptreact",
    "less",
    "pug",
    "sass",
    "scss",
    "svelte",
    "typescriptreact",
    "vue",
  },
  init_options = {
    showSuggestionsAsSnippets = true,
  },
}
lspconfig.volar.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  filetypes = { "vue" },
  init_options = {
    vue = {
      hybridMode = true,
    },
  },
  capabilities = vim.tbl_extend("keep", {
    workspace = {
      didChangeWatchedFiles = {
        -- NOTE: `dynamicRegistration: true` reduces greatly the performance on nvim < 0.10.0
        dynamicRegistration = true,
      },
    },
  }, nvlsp.capabilities),
}
lspconfig.eslint.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    run = "onSave",
  },
}


-- configuring single server, example: typescript
-- lspconfig.ts_ls.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }
