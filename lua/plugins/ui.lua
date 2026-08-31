require("onedarkpro").setup({ options = { transparency = true } })
vim.cmd.colorscheme("onedark")

require("which-key").setup({ preset = "modern", win = { border = "single" } })

require("bufferline").setup({
  options = {
    mode = "buffers",
    style_preset = require("bufferline").style_preset.minimal,
    show_tab_indicators = true,
    show_close_icon = true,
    separator_style = "thin",
    always_show_bufferline = false,
    diagnostics = "nvim_lsp",
    offsets = {
      { filetype = "oil", text = "File Explorer", highlight = "Directory", text_align = "left" },
    },
  },
})

require("todo-comments").setup()

require("noice").setup({
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
    },
    progress = { enabled = true },
    signature = { enabled = true },
    message = { enabled = true },
  },
  presets = {
    bottom_search = true,
    command_palette = true,
    long_message_to_split = true,
    inc_rename = false,
    lsp_doc_border = false,
  },
})
