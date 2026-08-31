vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.termguicolors = true
opt.cursorline = true
opt.laststatus = 3
opt.showmode = false

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftround = true
opt.smartindent = true
opt.autoindent = true
opt.formatoptions = "jcroqlnt"

opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "nosplit"
opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus"
opt.completeopt = "menu,menuone,noselect"

opt.updatetime = 200
opt.timeoutlen = 300
opt.splitright = true
opt.splitbelow = true
opt.splitkeep = "screen"
opt.scrolloff = 4
opt.sidescrolloff = 8
opt.smoothscroll = true
opt.undofile = true
opt.confirm = true
opt.wrap = false

vim.g.markdown_recommended_style = 0
vim.cmd("filetype plugin indent on")
