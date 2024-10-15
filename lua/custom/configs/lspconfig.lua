local base = require("plugins.init")
local on_attach = base.on_attach
local capabilities = base.capabilities

local lspconfig = require("lspconfig")

local servers = { "tailwindcss", "eslint", "pest_ls", "html", "bashls", "phpactor", "intelephense"}


for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({
    on_attach = on_attach,
    capabilities = capabilities
  })
end
local util = require("lspconfig/util")
lspconfig.gopls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl"},
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true
      }
    }
  }
})
local mason_registery = require("mason-registry")
local vue_ls_path = mason_registery.get_package('vue-language-server'):get_install_path() .. '/node_modules/@vue/language-server'

lspconfig.ts_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = vue_ls_path,
        languages = { "vue" }
      },
    },
  },
  filetypes = { 'typescript', 'javascript', 'vue' }
})

lspconfig.volar.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {"vue", "typescript", "javascript"},
  root_dir = util.root_pattern("package.json", ".git")
})
