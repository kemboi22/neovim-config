# 🚀 Elite Neovim Configuration

<!--toc:start-->

- [🚀 Elite Neovim Configuration](#🚀-elite-neovim-configuration)
  - [✨ Features](#features)
    - [Core Features](#core-features)
    - [AI-Powered Coding](#ai-powered-coding)
    - [Language Support](#language-support)
  - [🛠️ Complete Setup Guide](#🛠️-complete-setup-guide)
    - [Prerequisites](#prerequisites)
      - [1. Install Neovim (Latest Version)](#1-install-neovim-latest-version)
      - [2. Install Required Dependencies](#2-install-required-dependencies)
      - [3. Install Fonts (for icons)](#3-install-fonts-for-icons)
    - [🚀 Installation](#🚀-installation)
      - [Option 1: Clone This Configuration](#option-1-clone-this-configuration)
      - [Option 2: Fresh LazyVim Installation](#option-2-fresh-lazyvim-installation)
    - [🤖 AI Assistant Setup](#🤖-ai-assistant-setup)
      - [1. Run the Setup Script](#1-run-the-setup-script)
      - [2. Manual AI Setup (Alternative)](#2-manual-ai-setup-alternative)
        - [Install Ollama](#install-ollama)
        - [Setup Google Gemini (Optional)](#setup-google-gemini-optional)
    - [🔧 First Launch Setup](#🔧-first-launch-setup)
      - [1. Start Neovim](#1-start-neovim)
      - [2. Initial Plugin Installation](#2-initial-plugin-installation)
      - [3. Install Language Servers](#3-install-language-servers)
  - [📚 Configuration Structure](#📚-configuration-structure)
  - [⌨️ Essential Keybindings](#️-essential-keybindings)
    - [Leader Key](#leader-key)
    - [File Navigation](#file-navigation)
    - [Window Management](#window-management)
    - [Code Navigation](#code-navigation)
    - [AI Assistant (CodeCompanion)](#ai-assistant-codecompanion)
    - [AI Assistant (Avante - Cursor-like)](#ai-assistant-avante-cursor-like)
    - [Git Integration](#git-integration)
  - [🎨 Customization](#🎨-customization)
    - [Adding New Plugins](#adding-new-plugins)
    - [Modifying Keybindings](#modifying-keybindings)
    - [Changing Colorscheme](#changing-colorscheme)
    - [Language-Specific Configuration](#language-specific-configuration)
  - [🔧 Troubleshooting](#🔧-troubleshooting)
    - [Common Issues](#common-issues)
      - [1. Plugins Not Loading](#1-plugins-not-loading)
      - [2. Language Server Issues](#2-language-server-issues)
      - [3. AI Assistant Issues](#3-ai-assistant-issues)
      - [4. Performance Issues](#4-performance-issues)
    - [Reset Configuration](#reset-configuration)
  - [📦 Plugin List](#📦-plugin-list)
    - [Core Plugins (LazyVim)](#core-plugins-lazyvim)
    - [AI & Coding Assistant](#ai-coding-assistant)
    - [Language Support](#language-support)
    - [UI & Themes](#ui-themes)
  - [🚀 Advanced Usage](#🚀-advanced-usage)
    - [Custom AI Prompts](#custom-ai-prompts)
    - [Project-Specific Configuration](#project-specific-configuration)
  - [📖 Learning Resources](#📖-learning-resources)
  - [🤝 Contributing](#🤝-contributing)
  - [📄 License](#📄-license)
  <!--toc:end-->

A powerful, modern Neovim configuration built on LazyVim with AI-powered coding assistance, supporting multiple programming languages and providing a Cursor-like development experience.

## ✨ Features

### Core Features

- 🎯 **LazyVim Base**: Built on the robust LazyVim framework
- 🔌 **Plugin Management**: Lazy.nvim for efficient plugin loading
- 🎨 **Beautiful UI**: Multiple colorschemes (Catppuccin, OneDark)
- 📁 **File Explorer**: Neo-tree with advanced features
- 🔍 **Fuzzy Finding**: Telescope for files, grep, and more
- 📝 **LSP Integration**: Full Language Server Protocol support
- 🔧 **Treesitter**: Advanced syntax highlighting and code navigation

### AI-Powered Coding

- 🤖 **CodeCompanion.nvim**: Multi-provider AI assistance (Ollama + Gemini)
- ✨ **Avante.nvim**: Cursor-like inline AI suggestions
- 💬 **Interactive Chat**: AI-powered code discussions
- 🔍 **Code Review**: AI-assisted code analysis
- 🧪 **Test Generation**: Automatic unit test creation

### Language Support

- 🐹 **Go**: Complete Go development environment
- 🐘 **PHP**: Modern PHP development tools
- 🌐 **Web Development**: HTML, CSS, JavaScript, TypeScript
- 📊 **And many more**: Python, Rust, Java, C++, etc.

## 🛠️ Complete Setup Guide

### Prerequisites

#### 1. Install Neovim (Latest Version)

```bash
# Arch Linux
sudo pacman -S neovim

# Or build from source for latest features
git clone https://github.com/neovim/neovim
cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
```

#### 2. Install Required Dependencies

```bash
# Essential tools
sudo pacman -S git curl wget unzip tar gzip

# Language servers and tools
sudo pacman -S nodejs npm python python-pip

# Optional but recommended
sudo pacman -S ripgrep fd fzf lazygit
```

#### 3. Install Fonts (for icons)

```bash
# Nerd Fonts for icons
yay -S nerd-fonts-fira-code
# or
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.zip
unzip FiraCode.zip -d ~/.local/share/fonts/
fc-cache -fv
```

### 🚀 Installation

#### Option 1: Clone This Configuration

```bash
# Backup existing config (if any)
mv ~/.config/nvim ~/.config/nvim.backup

# Clone this configuration
git clone https://github.com/kemboi22/nvim-config ~/.config/nvim
cd ~/.config/nvim
```

#### Option 2: Fresh LazyVim Installation

```bash
# Remove existing config
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim

# Install LazyVim starter
git clone https://github.com/LazyVim/starter ~/.config/nvim
cd ~/.config/nvim
rm -rf .git

# Copy our AI assistant configuration
curl -o lua/plugins/ai-assistant.lua https://raw.githubusercontent.com/your-repo/ai-assistant.lua
```

### 🤖 AI Assistant Setup

#### 1. Run the Setup Script

```bash
cd ~/.config/nvim
chmod +x setup-ai-assistant.sh
./setup-ai-assistant.sh
```

#### 2. Manual AI Setup (Alternative)

##### Install Ollama

```bash
# Install Ollama
curl -fsSL https://ollama.ai/install.sh | sh

# Start Ollama service
ollama serve &
```

##### Setup Google Gemini (Optional)

1. Get an API key from [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Add to your shell configuration:

```bash
echo 'export GEMINI_API_KEY=your_api_key_here' >> ~/.bashrc
source ~/.bashrc
```

### 🔧 First Launch Setup

#### 1. Start Neovim

```bash
nvim
```

#### 2. Initial Plugin Installation

On first launch, LazyVim will automatically:

- Install all plugins
- Setup Language servers
- Configure everything

Wait for installation to complete, then restart Neovim.

#### 3. Install Language Servers

```vim
" In Neovim, install language servers
:Mason

" Install common servers:
" - lua_ls (Lua)
" - gopls (Go)
" - intelephense (PHP)
" - typescript-language-server (TypeScript/JavaScript)
" - pyright (Python)
" - rust_analyzer (Rust)
```

## 📚 Configuration Structure

```
~/.config/nvim/
├── init.lua                 # Entry point
├── lua/
│   ├── config/
│   │   ├── autocmds.lua     # Auto commands
│   │   ├── keymaps.lua      # Key mappings
│   │   ├── lazy.lua         # Plugin manager setup
│   │   ├── options.lua      # Neovim options
│   │   └── parser.lua       # Custom parsers
│   └── plugins/
│       ├── ai-assistant.lua # AI coding assistant
│       ├── example.lua      # Example plugin config
│       ├── lang-go.lua      # Go language support
│       ├── lang-php.lua     # PHP language support
│       ├── lang-web.lua     # Web development
│       └── ondedark.lua     # OneDark theme
├── setup-ai-assistant.sh   # AI setup script
└── README.md               # This file
```

## ⌨️ Essential Keybindings

### Leader Key

- **Leader**: `Space` (default LazyVim)
- **LocalLeader**: `\` (for buffer-local mappings)

### File Navigation

| Keybinding   | Description                     |
| ------------ | ------------------------------- |
| `<leader>e`  | Toggle file explorer (Neo-tree) |
| `<leader>ff` | Find files (Telescope)          |
| `<leader>fg` | Live grep (search in files)     |
| `<leader>fb` | Find buffers                    |
| `<leader>fr` | Recent files                    |
| `<leader>fc` | Find config files               |

### Window Management

| Keybinding    | Description              |
| ------------- | ------------------------ | ------------------ |
| `<C-h/j/k/l>` | Navigate between windows |
| `<leader>ww`  | Switch windows           |
| `<leader>wd`  | Delete window            |
| `<leader>w-`  | Split window below       |
| `<leader>w    | `                        | Split window right |

### Code Navigation

| Keybinding   | Description         |
| ------------ | ------------------- |
| `gd`         | Go to definition    |
| `gr`         | Go to references    |
| `K`          | Hover documentation |
| `<leader>ca` | Code actions        |
| `<leader>cr` | Rename symbol       |
| `<leader>cf` | Format document     |

### AI Assistant (CodeCompanion)

| Keybinding       | Mode          | Description          |
| ---------------- | ------------- | -------------------- |
| `<C-a>`          | Normal/Visual | Open AI actions menu |
| `<C-c>c`         | Normal        | Open AI chat         |
| `<C-c>i`         | Normal/Visual | Inline AI assistance |
| `<LocalLeader>a` | Normal/Visual | Toggle AI window     |
| `ga`             | Visual        | Add selection to AI  |
| `<leader>ccr`    | Visual        | AI code review       |
| `<leader>cct`    | Visual        | Generate tests       |

### AI Assistant (Avante - Cursor-like)

| Keybinding | Mode   | Description          |
| ---------- | ------ | -------------------- |
| `<M-l>`    | Insert | Accept AI suggestion |
| `<M-]>`    | Insert | Next suggestion      |
| `<M-[>`    | Insert | Previous suggestion  |
| `<C-]>`    | Insert | Dismiss suggestion   |

### Git Integration

| Keybinding   | Description      |
| ------------ | ---------------- |
| `<leader>gg` | LazyGit          |
| `<leader>gh` | Git hunk actions |
| `<leader>gb` | Git blame        |
| `<leader>gf` | Git file history |

## 🎨 Customization

### Adding New Plugins

Create a new file in `lua/plugins/` or add to existing files:

```lua
-- lua/plugins/my-plugin.lua
return {
  {
    "author/plugin-name",
    opts = {
      -- plugin configuration
    },
    keys = {
      { "<leader>mp", "<cmd>MyPlugin<cr>", desc = "My Plugin" },
    },
  },
}
```

### Modifying Keybindings

Edit `lua/config/keymaps.lua`:

```lua
-- Add custom keybindings
vim.keymap.set("n", "<leader>mp", "<cmd>MyCommand<cr>", { desc = "My Command" })
```

### Changing Colorscheme

Modify `lua/config/lazy.lua`:

```lua
{ "LazyVim/LazyVim", import = "lazyvim.plugins", opts = { colorscheme = "catppuccin" } },
```

### Language-Specific Configuration

Add files like `lua/plugins/lang-python.lua`:

```lua
return {
  -- Python-specific plugins and configuration
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "python" },
    },
  },
}
```

## 🔧 Troubleshooting

### Common Issues

#### 1. Plugins Not Loading

```bash
# Check plugin status
nvim --headless -c 'lua print(vim.inspect(require("lazy").stats()))' -c 'q'

# Or in Neovim
:Lazy
```

#### 2. Language Server Issues

```vim
" Check LSP status
:LspInfo

" Install/update language servers
:Mason
```

#### 3. AI Assistant Issues

```bash
# Check Ollama status
ollama list
pgrep ollama

# Check environment variables
echo $GEMINI_API_KEY
echo $OLLAMA_HOST
```

#### 4. Performance Issues

```vim
" Check startup time
:Lazy profile

" Disable unused plugins in lua/config/lazy.lua
```

### Reset Configuration

```bash
# Complete reset
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim

# Then reinstall
```

## 📦 Plugin List

### Core Plugins (LazyVim)

- **lazy.nvim**: Plugin manager
- **LazyVim**: Base configuration framework
- **which-key.nvim**: Keybinding help
- **telescope.nvim**: Fuzzy finder
- **neo-tree.nvim**: File explorer
- **nvim-lspconfig**: LSP configuration
- **nvim-treesitter**: Syntax highlighting
- **nvim-cmp**: Autocompletion

### AI & Coding Assistant

- **codecompanion.nvim**: AI coding assistant
- **avante.nvim**: Cursor-like AI experience
- **copilot.lua**: GitHub Copilot integration

### Language Support

- **Go**: gopls, go.nvim, gofumpt
- **PHP**: intelephense, php-cs-fixer
- **Web**: typescript-language-server, prettier
- **And many more via Mason**

### UI & Themes

- **catppuccin/nvim**: Catppuccin colorscheme
- **onedark.nvim**: OneDark colorscheme
- **lualine.nvim**: Statusline
- **bufferline.nvim**: Buffer tabs
- **indent-blankline.nvim**: Indentation guides

## 🚀 Advanced Usage

### Custom AI Prompts

Add custom prompts in `lua/plugins/ai-assistant.lua`:

```lua
prompt_library = {
  ["Explain Code"] = {
    strategy = "chat",
    description = "Explain the selected code",
    opts = {
      mapping = "<Leader>cce",
      modes = { "v" },
    },
    prompts = {
      {
        role = "system",
        content = "Explain this code in detail, including its purpose and how it works.",
      },
    },
  },
}
```

### Project-Specific Configuration

Create `.nvim.lua` in your project root:

```lua
-- Project-specific settings
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- Project-specific keybindings
vim.keymap.set("n", "<leader>pt", "<cmd>!npm test<cr>", { desc = "Run tests" })
```

## 📖 Learning Resources

- [LazyVim Documentation](https://lazyvim.github.io/)
- [Neovim Documentation](https://neovim.io/doc/)
- [Lua Guide for Neovim](https://github.com/nanotee/nvim-lua-guide)
- [CodeCompanion.nvim](https://github.com/olimorris/codecompanion.nvim)
- [Avante.nvim](https://github.com/yetone/avante.nvim)

## 🤝 Contributing

Feel free to:

1. Fork this configuration
2. Add your own customizations
3. Submit pull requests for improvements
4. Report issues

## 📄 License

This configuration is open source and available under the [MIT License](LICENSE).

---

**Happy coding with your AI-powered Neovim setup! 🚀✨**
