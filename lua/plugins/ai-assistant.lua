return {
  -- CodeCompanion.nvim for AI-powered coding assistance
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/nvim-cmp", -- Optional: for completion
      "nvim-telescope/telescope.nvim", -- Optional: for actions
    },
    config = function()
      require("codecompanion").setup({
        strategies = {
          chat = {
            adapter = "gemini",
          },
          inline = {
            adapter = "gemini",
          },
          agent = {
            adapter = "gemini",
          },
        },
        adapters = {
          ollama = function()
            return require("codecompanion.adapters").extend("ollama", {
              name = "ollama",
              schema = {
                model = {
                  default = "codellama:latest",
                  choices = {
                    "deepseek-coder-v2:latest",
                    "codellama:latest",
                    "llama3.1:latest",
                    "qwen2.5-coder:latest",
                  },
                },
                num_ctx = {
                  default = 16384,
                },
                num_predict = {
                  default = -1,
                },
              },
            })
          end,
          gemini = function()
            return require("codecompanion.adapters").extend("gemini", {
              name = "gemini",
              env = {},
              headers = {
                ["content-type"] = "application/json",
              },
              parameters = {
                sync = true,
              },
              schema = {
                model = {
                  default = "gemini-2.0-flash",
                  choices = {
                    "gemini-1.5-pro-latest",
                    "gemini-2.0-flash",
                    "gemini-1.5-flash-8b-latest",
                  },
                },
              },
            })
          end,
        },
        display = {
          action_palette = {
            width = 95,
            height = 10,
            prompt = "Prompt ",
            provider = "default", -- default|telescope
          },
          chat = {
            window = {
              layout = "vertical", -- float|vertical|horizontal|buffer
              width = 0.45,
              height = 0.8,
              relative = "editor",
              opts = {
                breakindent = true,
                cursorcolumn = false,
                cursorline = false,
                foldcolumn = "0",
                linebreak = true,
                list = false,
                signcolumn = "no",
                spell = false,
                wrap = true,
              },
            },
            intro_message = "Welcome to CodeCompanion ✨\n\nPress ? for options",
            separator = "─",
            show_header_separator = true,
            show_references = true,
          },
        },
        opts = {
          -- Global options
          log_level = "ERROR", -- TRACE|DEBUG|ERROR|INFO
          send_code = true, -- Send code context with requests
          use_default_actions = true, -- Use default actions
          use_default_prompt_library = true, -- Use default prompts
        },
        prompt_library = {
          ["Custom Code Review"] = {
            strategy = "chat",
            description = "Review the selected code for improvements",
            opts = {
              mapping = "<Leader>ccr",
              modes = { "v" },
              short_name = "review",
              auto_submit = true,
              user_prompt = false,
              stop_context_insertion = true,
            },
            prompts = {
              {
                role = "system",
                content = function(context)
                  return "I want you to act as a senior software engineer and review the following code. Focus on:\n\n"
                    .. "1. Code quality and best practices\n"
                    .. "2. Potential bugs or issues\n"
                    .. "3. Performance improvements\n"
                    .. "4. Readability and maintainability\n"
                    .. "5. Security considerations\n\n"
                    .. "Please provide specific, actionable feedback."
                end,
              },
              {
                role = "user",
                content = function(context)
                  local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                  return "Please review this code:\n\n```" .. context.filetype .. "\n" .. code .. "\n```"
                end,
                opts = {
                  contains_code = true,
                },
              },
            },
          },
          ["Generate Tests"] = {
            strategy = "chat",
            description = "Generate unit tests for the selected code",
            opts = {
              mapping = "<Leader>cct",
              modes = { "v" },
              short_name = "tests",
              auto_submit = true,
            },
            prompts = {
              {
                role = "system",
                content = "Generate comprehensive unit tests for the provided code. Include edge cases and consider the testing framework commonly used for this language.",
              },
              {
                role = "user",
                content = function(context)
                  local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                  return "Generate unit tests for this code:\n\n```" .. context.filetype .. "\n" .. code .. "\n```"
                end,
                opts = {
                  contains_code = true,
                },
              },
            },
          },
        },
      })
    end,
    cmd = {
      "CodeCompanion",
      "CodeCompanionActions",
      "CodeCompanionToggle",
      "CodeCompanionAdd",
    },
    keys = {
      { "<C-a>", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "Code Companion Actions" },
      { "<LocalLeader>a", "<cmd>CodeCompanionToggle<cr>", mode = { "n", "v" }, desc = "Toggle Code Companion" },
      { "ga", "<cmd>CodeCompanionAdd<cr>", mode = "v", desc = "Add to Code Companion" },
      { "<C-c>c", "<cmd>CodeCompanion<cr>", mode = "n", desc = "Code Companion Chat" },
      { "<C-c>i", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "Inline Code Companion" },
    },
  },

  -- Avante.nvim for Cursor-like AI experience
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
      -- add any opts here
      provider = "gemini",
      auto_suggestions = true,
      providers = {
        claude = {
          endpoint = "https://api.anthropic.com",
          model = "claude-3-5-sonnet-20241022",
        },
        ollama = {
          ["local"] = true,
          model = "codellama:latest",
          parse_curl_args = function(opts, code_opts)
            return {
              url = opts.endpoint .. "/chat/completions",
              headers = {
                ["Accept"] = "application/json",
                ["Content-Type"] = "application/json",
              },
              body = {
                model = opts.model,
                messages = opts.messages,
                max_tokens = 2048,
                stream = true,
              },
            }
          end,
        },
        gemini = {
          endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
          model = "gemini-2.0-flash",
          timeout = 30000, -- Timeout in milliseconds
          temperature = 0,
          ["local"] = false,
        },
      },
      mappings = {
        --- @class AvanteConflictMappings
        diff = {
          ours = "co",
          theirs = "ct",
          all_theirs = "ca",
          both = "cb",
          cursor = "cc",
          next = "]x",
          prev = "[x",
        },
        suggestion = {
          accept = "<M-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
        jump = {
          next = "]]>",
          prev = "[[",
        },
        submit = {
          normal = "<CR>",
          insert = "<C-s>",
        },
        sidebar = {
          switch_windows = "<Tab>",
          reverse_switch_windows = "<S-Tab>",
        },
      },
      hints = { enabled = true },
      windows = {
        position = "right", -- the position of the sidebar
        wrap = true, -- similar to vim.o.wrap
        width = 30, -- default % based on available width
        sidebar_header = {
          align = "center", -- left, center, right for title
          rounded = true,
        },
      },
      highlights = {
        ---@type AvanteConflictHighlights
        diff = {
          current = "DiffText",
          incoming = "DiffAdd",
        },
      },
      --- @class AvanteConflictUserConfig
      diff = {
        autojump = true,
        ---@type string | fun(): string
        list_opener = "copen",
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },

  -- Additional AI-related utilities
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>c", group = "AI Code Assistant" },
        { "<leader>cc", group = "CodeCompanion" },
        { "<leader>ca", group = "Avante" },
      },
    },
  },
}
