local capabilities = require("blink.cmp").get_lsp_capabilities()
vim.lsp.config("*", { capabilities = capabilities })

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file("", true) },
      telemetry = { enable = false },
    },
  },
})

local mason_packages = vim.fn.stdpath("data") .. "/mason/packages"
local global_plugins = {
  {
    name = "@vue/typescript-plugin",
    location = mason_packages .. "/vue-language-server/node_modules/@vue/language-server",
    languages = { "vue" },
    configNamespace = "typescript",
    enableForWorkspaceTypeScriptVersions = true,
  },
  {
    name = "typescript-svelte-plugin",
    location = mason_packages .. "/svelte-language-server/node_modules/typescript-svelte-plugin",
    enableForWorkspaceTypeScriptVersions = true,
  },
}

vim.lsp.config("vtsls", {
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
  settings = {
    vtsls = {
      autoUseWorkspaceTsdk = true,
      tsserver = { globalPlugins = global_plugins },
    },
    typescript = {
      preferences = {
        includePackageJsonAutoImports = "auto",
        importModuleSpecifier = "non-relative",
      },
      suggest = {
        completeFunctionCalls = true,
        includeCompletionsForModuleExports = true,
        includeCompletionsWithInsertText = true,
      },
    },
  },
})

vim.lsp.config("pyright", {
  before_init = function(_, config)
    -- Point pyright at the project interpreter so third-party deps resolve.
    -- Without this it uses system python and reports `reportMissingImports`
    -- for everything installed in the project venv (e.g. via `uv sync`).
    local candidates = {}
    -- 1. Explicitly activated environment first.
    local activated = vim.env.VIRTUAL_ENV or vim.env.CONDA_PREFIX
    if activated and activated ~= "" then
      table.insert(candidates, activated .. "/bin/python")
    end
    -- 2. Local venv in the project root (`uv sync` creates `.venv`).
    local root = config.root_dir or vim.fn.getcwd()
    for _, dir in ipairs({ ".venv", "venv" }) do
      table.insert(candidates, root .. "/" .. dir .. "/bin/python")
    end
    for _, python in ipairs(candidates) do
      if vim.fn.executable(python) == 1 then
        -- NB: mutate in place. The client snapshots `config.settings` by
        -- reference at startup, so rebinding (`config.settings = ...`) would
        -- silently drop the change and pyright would keep using system python.
        local settings = config.settings or {}
        settings.python = settings.python or {}
        settings.python.pythonPath = python
        config.settings = settings
        return
      end
    end
  end,
})

vim.lsp.config("kotlin_language_server", {
  -- Attach outside Gradle/Maven projects too (single files, git repos).
  -- Upstream only uses build files as root_markers, so lone .kt files
  -- never start the server -> no completions.
  root_markers = {
    "settings.gradle",
    "settings.gradle.kts",
    "build.gradle",
    "build.gradle.kts",
    "pom.xml",
    "build.xml",
    ".git",
  },
  -- Upstream sets storagePath = vim.fs.root(...) which is nil outside a
  -- project. That serializes init_options as [] instead of {}, and the
  -- server crashes with "Expected BEGIN_OBJECT but was BEGIN_ARRAY".
  -- Point it at a real cache dir instead.
  init_options = {
    storagePath = vim.fn.stdpath("cache") .. "/kotlin-language-server",
  },
})

local servers = {
  "bashls",
  "clangd",
  "docker_compose_language_service",
  "dockerls",
  "gopls",
  "intelephense",
  "jdtls",
  "jsonls",
  "kotlin_language_server",
  "lua_ls",
  "ols",
  "oxlint",
  "prismals",
  "pyright",
  "rust_analyzer",
  "svelte",
  "tailwindcss",
  "vtsls",
  "vue_ls",
  "yamlls",
  "zls",
}

vim.lsp.enable(servers)

local lsp_group = vim.api.nvim_create_augroup("config_lsp", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
  group = lsp_group,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    local function map(lhs, rhs, desc, mode)
      vim.keymap.set(mode or "n", lhs, rhs, { buffer = args.buf, desc = desc })
    end

    map("gd", vim.lsp.buf.definition, "Go to Definition")
    map("gr", vim.lsp.buf.references, "Show References")
    map("K", vim.lsp.buf.hover, "Hover Docs")
    map("<leader>ca", vim.lsp.buf.code_action, "Code Action", { "n", "v" })
    map("<leader>cr", vim.lsp.buf.rename, "Rename Symbol")

    if client.name == "vtsls" or client.name == "vue_ls" then
      vim.lsp.inlay_hint.enable(false, { bufnr = args.buf })
    elseif client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end

    if
      client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight)
      and not vim.b[args.buf].lsp_document_highlight
    then
      vim.b[args.buf].lsp_document_highlight = true
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = lsp_group,
        buffer = args.buf,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        group = lsp_group,
        buffer = args.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})
