local utils = require "custom.utils"
local lazyUtils = require "custom.utils.lazy"
local nvimtreeUtils = require "custom.utils.nvimtree"
local keymapsUtils = require "custom.utils.keymaps"
local in_leetcode = require("custom.utils.constants").in_leetcode

return {
  {
    "stevearc/oil.nvim",
    cmd = { "Oil" },
    keys = {
      {
        "<leader>o",
        "<cmd>Oil<CR>",
        desc = "open Oil",
      },
    },
    opts = {
      columns = {
        {
          "permissions",
          highlight = function(permission_str)
            local hls = {}
            local permission_hlgroups = {
              ["-"] = "OilHyphen",
              ["r"] = "OilRead",
              ["w"] = "OilWrite",
              ["x"] = "OilExecute",
            }
            for i = 1, #permission_str do
              local char = permission_str:sub(i, i)
              table.insert(hls, { permission_hlgroups[char], i - 1, i })
            end
            return hls
          end,
        },
        { "size", highlight = "OilSize" },
        { "mtime", highlight = "OilMtime" },
        {
          "icon",
          default_file = "󰈚",
          directory = "",
          add_padding = false,
        },
      },
      win_options = {
        signcolumn = "yes",
        cursorcolumn = true,
      },
      delete_to_trash = true,
      use_default_keymaps = false,
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
        ["q"] = "actions.close",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["gs"] = "actions.change_sort",
        ["g."] = "actions.toggle_hidden",
        ["g\\"] = "actions.toggle_trash",

        ["<C-v>"] = "actions.select_vsplit",
        ["<C-x>"] = "actions.select_split",
        ["<C-r>"] = "actions.refresh",
        ["o"] = "actions.open_external",
      },
      view_options = {
        show_hidden = true,
      },
    },
  },

  {
    "nvim-tree/nvim-tree.lua",
    -- enabled = false,
    event = "VeryLazy",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    keys = (in_leetcode and {}) or {
      {
        "<leader>b",
        "<cmd>NvimTreeToggle<CR>",
        desc = "toggle nvimtree",
      },
      {
        "<leader>B",
        function()
          local api = require "nvim-tree.api"
          api.tree.toggle {
            find_file = false,
            focus = true,
            path = utils.get_buffer_root_path(),
            update_root = false,
          }
        end,
        desc = "toggle nvimtree (relative root dir)",
      },
      {
        "<leader>e",
        "<cmd>NvimTreeFocus<CR>",
        desc = "focus nvimtree",
      },
    },
    opts = {
      filters = {
        exclude = { vim.fn.stdpath "config" .. "/lua/custom" },
        custom = { "^.git$" },
      },
      on_attach = nvimtreeUtils.on_attach,
      respect_buf_cwd = false,
      update_cwd = false,
      disable_netrw = true,
      hijack_cursor = true,
      sync_root_with_cwd = true,
      update_focused_file = {
        enable = true,
      },
      view = {
        side = "right",
        preserve_window_proportions = false,
        width = {
          min = 49,
          max = 49,
          padding = 2,
        },
        signcolumn = "no",
      },
      git = {
        enable = true,
        ignore = false,
        show_on_dirs = true,
        show_on_open_dirs = false,
      },
      filesystem_watchers = {
        enable = true,
      },
      actions = {
        open_file = {
          window_picker = {
            picker = function()
              local ok, winid = pcall(require("window-picker").pick_window)

              if not ok then
                return -1
              end

              return winid
            end,
          },
        },
      },
      modified = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = false,
      },
      renderer = {
        root_folder_label = false,
        group_empty = false,
        special_files = {},
        highlight_git = "name",
        icons = {
          git_placement = "after",
          show = {
            bookmarks = false,
            diagnostics = false,
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
            modified = true,
          },
          glyphs = {
            default = "󰈚",
            symlink = "",
            modified = "",
            folder = {
              default = "",
              empty = "",
              empty_open = "",
              open = "",
              symlink = "",
              symlink_open = "",
              arrow_open = " ",
              arrow_closed = " ",
            },
            git = {
              unstaged = "󰄱",
              staged = "",
              unmerged = "",
              renamed = "󰁕",
              untracked = "",
              deleted = "",
              ignored = "",
            },
          },
        },
      },
    },
  },
  {
    "antosha417/nvim-lsp-file-operations",
    event = "LspAttach",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      operations = {
        willRenameFiles = true,
        didRenameFiles = true,
        willCreateFiles = false,
        didCreateFiles = false,
        willDeleteFiles = false,
        didDeleteFiles = false,
      },
      timeout_ms = 1000,
    },
    config = function(_, opts)
      lazyUtils.on_load("nvim-tree.lua", function()
        require("lsp-file-operations").setup(opts)
      end)
    end,
  },

  {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit", "LazyGitConfig", "LazyGitFilter" },
    keys = {
      {
        "<leader>gl",
        "<cmd>LazyGit<CR>",
        desc = "open lazygit",
      },
      {
        "<leader>gL",
        "<cmd>LazyGitCurrentFile<CR>",
        desc = "open lazygit (relative root dir)",
      },
    },
    init = function()
      vim.g.lazygit_floating_window_scaling_factor = 1 -- scaling factor for floating window
    end,
  },

  {
    "folke/trouble.nvim",
    tag = "v2.10.0",
    cmd = { "TroubleToggle", "Trouble" },
    keys = {
      {
        "<leader>xx",
        "<cmd>TroubleToggle<cr>",
        desc = "show last list",
      },
      {
        "<leader>xw",
        "<cmd>TroubleToggle workspace_diagnostics<cr>",
        desc = "show project diagnostics",
      },
      {
        "<leader>xf",
        "<cmd>TroubleToggle document_diagnostics<cr>",
        desc = "show file diagnostic",
      },
      {
        "<leader>xl",
        "<cmd>TroubleToggle loclist<cr>",
        desc = "toggle loclist",
      },
      {
        "<leader>xq",
        "<cmd>TroubleToggle quickfix<cr>",
        desc = "toggle quicklist",
      },
      {
        "[x",
        "<cmd>lua require('trouble').previous({ jump = true })<CR>",
        desc = "go to prev troublelist item",
      },
      {
        "]x",
        "<cmd>lua require('trouble').next({ jump = true })<CR>",
        desc = "go to next troublelist item",
      },
    },
    init = function()
      utils.autocmd("FileType", {
        group = utils.augroup "trouble_better_ux",
        pattern = "Trouble",
        callback = function()
          vim.opt_local.number = true
          vim.opt_local.relativenumber = true
          vim.opt_local.signcolumn = "yes"
          vim.defer_fn(function()
            pcall(vim.api.nvim_win_set_cursor, 0, { 1, 1 })
          end, 0)
        end,
      })
      utils.autocmd("FileType", {
        group = utils.augroup "hijack_quickfix_and_location_list",
        pattern = "qf",
        callback = function()
          local trouble = require "trouble"
          if vim.fn.getloclist(0, { filewinid = 1 }).filewinid ~= 0 then
            vim.defer_fn(function()
              vim.cmd.lclose()
              trouble.open "loclist"
            end, 0)
          else
            vim.defer_fn(function()
              vim.cmd.cclose()
              trouble.open "quickfix"
            end, 0)
          end
        end,
      })
    end,
    opts = {
      use_diagnostic_signs = true,
      group = false,
      padding = false,
      indent_lines = false,
      auto_jump = {},
      multiline = false,
    },
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      defaults = {
        ["<leader>x"] = { name = "trouble" },
      },
    },
  },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
    keys = {
      {
        "<leader>gf",
        "<cmd>DiffviewFileHistory %<CR>",
        desc = "open current file history",
      },
    },
    opts = {
      enhanced_diff_hl = false,
      show_help_hints = false,
      file_panel = {
        listing_style = "list",
      },
      file_history_panel = {
        log_options = {
          git = {
            single_file = {
              diff_merges = "first-parent",
            },
          },
        },
      },
      hooks = {
        diff_buf_read = function()
          vim.opt_local.wrap = false
        end,
        diff_buf_win_enter = function(bufnr, winid, ctx)
          if ctx.layout_name:match "^diff2" then
            if ctx.symbol == "a" then
              vim.opt_local.winhl = table.concat({
                "DiffAdd:DiffviewDiffAddAsDelete",
                "DiffDelete:DiffviewDiffDeleteSign",
                "DiffChange:DiffviewDiffDelete",
                "DiffText:DiffviewDiffDeleteText",
              }, ",")
            elseif ctx.symbol == "b" then
              vim.opt_local.winhl = table.concat({
                "DiffDelete:DiffviewDiffDeleteSign",
                "DiffChange:DiffviewDiffAdd",
                "DiffText:DiffviewDiffAddText",
              }, ",")
            end
          end
        end,
      },
    },
  },

  {
    "nvim-pack/nvim-spectre",
    keys = {
      {
        "<leader>fs",
        "<cmd>lua require('spectre').open()<CR>",
        desc = "find word spectre",
      },
    },
    opts = {
      highlight = {
        ui = "String",
        search = "SpectreSearch",
        replace = "DiffAdd",
      },
      mapping = {
        ["send_to_qf"] = {
          map = "<C-q>",
          cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
          desc = "send all item to quickfix",
        },
      },
    },
  },

  {
    "wochap/telescope.nvim",
    branch = "feat/vimgrep--json-may-2024",
    event = "VeryLazy",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        enabled = vim.fn.executable "make" == 1,
        config = function()
          lazyUtils.on_load("telescope.nvim", function()
            require("telescope").load_extension "fzf"
          end)
        end,
      },
    },
    keys = (in_leetcode and {})
      or {
        {
          "<leader>cf",
          "<cmd>Telescope filetypes<cr>",
          desc = "change filetype",
        },

        -- find
        {
          "<leader>fw",
          "<cmd>lua require'custom.utils.telescope'.live_grep()<CR>",
          desc = "find word",
        },
        {
          "<leader>fy",
          "<cmd>lua require'custom.utils.telescope'.symbols()<CR>",
          desc = "find symbols",
        },
        {
          "<leader>fo",
          "<cmd>Telescope oldfiles<CR>",
          desc = "find old files",
        },
        {
          "<leader>fg",
          "<cmd>Telescope git_status<CR>",
          desc = "find changed files",
        },
        {
          "<leader>fb",
          "<cmd>Telescope buffers sort_mru=true sort_lastused=true <CR>",
          desc = "find buffers",
        },
        {
          "<leader>ff",
          "<cmd>Telescope find_files find_command=fd,--fixed-strings,--type,f follow=true hidden=true <CR>",
          desc = "find files",
        },
        {
          "<leader>fa",
          "<cmd>Telescope find_files find_command=fd,--fixed-strings,--type,f,--exclude,node_modules follow=true hidden=true no_ignore=true <CR>",
          desc = "find files!",
        },
        {
          "<leader>fx",
          "<cmd>Telescope marks<CR>",
          desc = "find marks",
        },
        {
          "<leader>fp",
          "<cmd>lua require'custom.utils.telescope'.projects()<CR>",
          desc = "change project",
        },
      },
    opts = function()
      local actions = require "telescope.actions"
      local sorters = require "telescope.sorters"
      return {
        defaults = {
          vimgrep_arguments = {
            "rg",
            "-L",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
          },
          prompt_prefix = "   ",
          selection_caret = "  ",
          entry_prefix = "  ",
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          file_sorter = sorters.get_fuzzy_file,
          file_ignore_patterns = { "%.git/", "%.lock$", "%-lock.json$", "%.direnv/" },
          generic_sorter = sorters.get_generic_fuzzy_sorter,
          path_display = { "truncate", "filename_first" },
          winblend = 0,
          border = {},
          set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
          mappings = {
            i = {
              ["<C-Down>"] = actions.cycle_history_next,
              ["<C-Up>"] = actions.cycle_history_prev,
              ["<esc>"] = actions.close,
              ["<C-S-v>"] = keymapsUtils.commandPaste,
              ["<CR>"] = actions.select_default,
              ["<S-CR>"] = function(prompt_bufnr)
                local action_set = require "telescope.actions.set"
                action_set.edit(prompt_bufnr, "WindowPicker")
              end,
            },
          },
          pickers = {
            oldfiles = {
              cwd_only = true,
            },
          },
          preview = {
            filesize_limit = 0.5,
            highlight_limit = 0.5,
            filetype_hook = function(filepath, _, _)
              return not utils.is_minfile(filepath)
            end,
          },
        },

        extensions_list = { "fzf" },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require "telescope"
      telescope.setup(opts)

      -- load extensions
      for _, ext in ipairs(opts.extensions_list) do
        telescope.load_extension(ext)
      end
    end,
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    init = function()
      utils.autocmd({ "CmdlineLeave", "CmdlineEnter" }, {
        group = utils.augroup "turn_off_flash_search",
        callback = function()
          local has_flash, flash = pcall(require, "flash")
          if not has_flash then
            return
          end
          pcall(flash.toggle, false)
        end,
      })
    end,
    keys = {
      {
        "s",
        function()
          require("flash").jump()
        end,
        desc = "Flash",
        mode = { "n", "x", "o" },
      },
      {
        "<A-s>",
        function()
          require("flash").jump { continue = true }
        end,
        desc = "Flash",
        mode = { "n", "x", "o" },
      },
      {
        "S",
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
        mode = { "n", "o", "x" },
      },
      {
        "r",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
        mode = "o",
      },
      {
        "R",
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
        mode = { "o", "x" },
      },
      {
        "<C-s>",
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
        mode = { "c" },
      },
    },
    opts = {
      search = {
        multi_window = false,
      },
      modes = {
        char = {
          enabled = false,
          jump_labels = true,
          multi_line = false,
        },
      },
      prompt = {
        enabled = true,
        prefix = { { " FLASH ", "FlashPromptMode" }, { " ", "FlashPromptModeSep" } },
      },
    },
  },
  -- integrate flash in telescope
  {
    "wochap/telescope.nvim",
    optional = true,
    opts = function(_, opts)
      local flash = require("custom.utils.telescope").flash
      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        mappings = { n = { s = flash }, i = { ["<c-s>"] = flash } },
      })
    end,
  },

  {
    "akinsho/git-conflict.nvim",
    version = "*",
    event = "VeryLazy",
    opts = {
      default_mappings = {
        ours = "<leader>gco",
        theirs = "<leader>gct",
        none = "<leader>gc0",
        both = "<leader>gcb",
        next = "]c",
        prev = "[c",
      },
    },
    config = function(_, opts)
      vim.api.nvim_create_autocmd("User", {
        pattern = "GitConflictDetected",
        callback = function(event)
          lazyUtils.on_load("which-key.nvim", function()
            local wk = require "which-key"
            wk.register({
              ["<leader>gc"] = { name = "git conflict" },
            }, { buffer = event.buf })
          end)
        end,
      })

      require("git-conflict").setup(opts)
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    event = "LazyFile",
    opts = {
      signs = {
        add = {
          hl = "GitSignsAdd",
          text = "▍",
        },
        change = {
          hl = "GitSignsChange",
          text = "▍",
        },
        delete = {
          hl = "GitSignsDelete",
          text = "",
        },
        changedelete = {
          hl = "GitSignsChange",
          text = "▍",
        },
        topdelete = {
          hl = "GitSignsDelete",
          text = "",
        },
        untracked = {
          hl = "GitSignsAdd",
          text = "", -- PERF: a lot of signs with statuscol.nvim causes lag
        },
      },
      preview_config = {
        row = 1,
      },
      _signs_staged_enable = true,
      _signs_staged = {
        add = {
          hl = "GitSignsStagedAdd",
          text = "▍",
        },
        change = {
          hl = "GitSignsStagedChange",
          text = "▍",
        },
        delete = {
          hl = "GitSignsStagedDelete",
          text = "",
        },
        changedelete = {
          hl = "GitSignsStagedChange",
          text = "▍",
        },
        topdelete = {
          hl = "GitSignsStagedDelete",
          text = "",
        },
      },
      attach_to_untracked = true,
      on_attach = function(bufnr)
        local map = keymapsUtils.map
        map("n", "]g", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            require("gitsigns").next_hunk()
          end)
          return "<Ignore>"
        end, "jump to next hunk", { expr = true, buffer = bufnr })
        map("n", "[g", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            require("gitsigns").prev_hunk()
          end)
          return "<Ignore>"
        end, "jump to prev hunk", { expr = true, buffer = bufnr })
        map("n", "<leader>gS", "<cmd>lua require('gitsigns').stage_buffer()<cr>", "stage buffer", { buffer = bufnr })
        map("n", "<leader>gs", "<cmd>lua require('gitsigns').stage_hunk()<cr>", "stage hunk", { buffer = bufnr })
        map("n", "<leader>gR", "<cmd>lua require('gitsigns').reset_buffer()<cr>", "reset buffer", { buffer = bufnr })
        map("n", "<leader>gr", "<cmd>lua require('gitsigns').reset_hunk()<cr>", "reset hunk", { buffer = bufnr })
        map("n", "<leader>gp", "<cmd>lua require('gitsigns').preview_hunk()<cr>", "preview hunk", { buffer = bufnr })
        map(
          "n",
          "<leader>gb",
          "<cmd>lua require('gitsigns').blame_line({ full = true })<cr>",
          "blame line",
          { buffer = bufnr }
        )
        map(
          "n",
          "<leader>gd",
          "<cmd>lua require('gitsigns').toggle_deleted()<cr>",
          "toggle deleted",
          { buffer = bufnr }
        )
      end,
    },
  },
}
