# Neovim Configuration

A fast, modular Neovim 0.12 configuration built with the native `vim.pack` package manager and native `vim.lsp` client.

## Layout

```text
.
├── init.lua                  # Small bootstrap
├── lua/config/               # Options, keymaps, diagnostics, autocmds
├── lua/lsp/                  # Native LSP server configuration
├── lua/plugins/              # Package and feature configuration
└── configs/                  # Shared formatter defaults
```

## Language support

- JavaScript and TypeScript use `vtsls` exclusively.
- Vue uses `vue_ls` for HTML/CSS plus `vtsls` for TypeScript in Vue SFCs.
- Svelte uses `svelte-language-server` with the TypeScript Svelte plugin registered in `vtsls`.
- Lua, Go, Rust, Zig, Odin, Python, PHP, C/C++, Bash, Docker, Prisma, JSON, and Tailwind have native LSP configurations.
- SQL has Treesitter highlighting and indentation, Blink keyword/buffer completion, and SQLFluff linting and formatting. It uses project configuration when available and ANSI as the fallback dialect.

Mason installs missing tools in the background after startup. Use `:Mason` to inspect them or `:MasonToolsInstall` to install the configured set immediately.

## Formatting

Formatting runs automatically before save through Conform:

- Oxfmt: JavaScript, TypeScript, Vue, Svelte, JSON, CSS, HTML, Markdown, YAML, and TOML
- Native tools: Stylua, gofmt/goimports, rustfmt, zig fmt, odinfmt, shfmt, and clang-format
- SQLFluff: SQL, MySQL, and PL/SQL, with ANSI as the fallback dialect
- PHP CS Fixer and Blade Formatter: PHP and Blade templates

Oxfmt's Svelte support requires the project to have `svelte` installed so it can load `svelte/compiler`, as normal Svelte and SvelteKit projects do.

Commands:

| Command | Behavior |
| --- | --- |
| `:FormatDisable` | Disable format-on-save for the current buffer |
| `:FormatEnable` | Enable format-on-save for the current buffer |
| `:FormatDisable!` | Disable format-on-save globally |
| `:FormatEnable!` | Enable format-on-save globally |
| `:ConformInfo` | Show formatter availability and logs |

## Important keymaps

| Key | Action |
| --- | --- |
| `<leader>E` | Open Oil explorer |
| `<leader>e` | Find files |
| `<leader>ff` | Find files |
| `<leader>fg` / `<leader>/` | Live grep |
| `<leader>cf` | Format current file |
| `<leader>cl` | Lint current file |
| `<leader>ca` | LSP code action |
| `<leader>cr` | LSP rename |
| `gd` / `gr` | Definitions / references |
| `gI` / `gy` | Implementations / type definitions |
| `<C-h/j/k/l>` | Move between windows |
| `<C-s>` | Save file |
| `<Tab>` / `<S-Tab>` | Next / previous buffer |
| `s` | Flash jump |

In insert mode, Enter accepts a selected completion. Otherwise it falls through to nvim-autopairs and Neovim's filetype indentation, producing a correctly indented newline.

## Package management

Plugins are declared in `lua/config/pack.lua`. The generated `nvim-pack-lock.json` is committed so installs are reproducible.

Useful commands:

```vim
:lua vim.pack.update()
:checkhealth
:LspInfo
:ConformInfo
```
