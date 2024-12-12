local lazyUtils = require "custom.utils.lazy"

return {
  {
    "ThePrimeagen/refactoring.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      {
        "<leader>r",
        "",
        desc = "refactor",
        mode = { "n", "v" },
      },

      {
        "<leader>rs",
        function()
          return require("telescope").extensions.refactoring.refactors()
        end,
        mode = "v",
        desc = "Refactor",
      },
      {
        "<leader>ri",
        function()
          require("refactoring").refactor "Inline Variable"
        end,
        mode = { "n", "v" },
        desc = "Inline Variable",
      },
      {
        "<leader>rb",
        function()
          require("refactoring").refactor "Extract Block"
        end,
        desc = "Extract Block",
      },
      {
        "<leader>rf",
        function()
          require("refactoring").refactor "Extract Block To File"
        end,
        desc = "Extract Block To File",
      },
      {
        "<leader>rP",
        function()
          require("refactoring").debug.printf { below = false }
        end,
        desc = "Debug Print",
      },
      {
        "<leader>rp",
        function()
          require("refactoring").debug.print_var { normal = true }
        end,
        desc = "Debug Print Variable",
      },
      {
        "<leader>rc",
        function()
          require("refactoring").debug.cleanup {}
        end,
        desc = "Debug Cleanup",
      },
      {
        "<leader>rf",
        function()
          require("refactoring").refactor "Extract Function"
        end,
        mode = "v",
        desc = "Extract Function",
      },
      {
        "<leader>rF",
        function()
          require("refactoring").refactor "Extract Function To File"
        end,
        mode = "v",
        desc = "Extract Function To File",
      },
      {
        "<leader>rx",
        function()
          require("refactoring").refactor "Extract Variable"
        end,
        mode = "v",
        desc = "Extract Variable",
      },
      {
        "<leader>rp",
        function()
          require("refactoring").debug.print_var()
        end,
        mode = "v",
        desc = "Debug Print Variable",
      },
    },
    opts = {
      prompt_func_return_type = {
        go = false,
        java = false,
        cpp = false,
        c = false,
        h = false,
        hpp = false,
        cxx = false,
      },
      prompt_func_param_type = {
        go = false,
        java = false,
        cpp = false,
        c = false,
        h = false,
        hpp = false,
        cxx = false,
      },
      printf_statements = {},
      print_var_statements = {},
      show_success_message = true, -- shows a message with information about the refactor on success
      -- i.e. [Refactor] Inlined 3 variable occurrences
    },
    config = function(_, opts)
      require("refactoring").setup(opts)
      lazyUtils.on_load("telescope.nvim", function()
        require("telescope").load_extension "refactoring"
      end)
    end,
  },
  {
    "danymat/neogen",
    config = function()
      require("neogen").setup {
        enabled = true, -- Enable Neogen
        languages = {
          php = {
            template = {
              annotation_convention = "phpdoc", -- Use PHPDoc as the standard
            },
          },
          -- Add other languages if needed
        },
      }

      -- Custom function to generate docblocks for different languages
      local function generate_docblock(line, lang)
        if lang == "php" then
          local func_name, param_type, param_name = string.match(line, "public function (.-)%((.-) (.-)%)")
          if func_name and param_type and param_name then
            return {
              "/**",
              string.format(" * @param %s $%s", param_type, param_name),
              " */",
            }
          end
        elseif lang == "typescript" or lang == "javascript" then
          local func_name, params = string.match(line, "function%s+(.-)%((.-)%)")
          if func_name and params then
            return {
              "/**",
              string.format(" * Function %s", func_name),
              " * @param {Type} param_name - Description", -- Placeholder for params
              " * @returns {Type} - Description", -- Placeholder for return type
              " */",
            }
          end
        elseif lang == "java" or lang == "c#" then
          local return_type, func_name, params = string.match(line, "(%w+)%s+(%w+)%((.-)%)")
          if func_name then
            return {
              "/**",
              string.format(" * %s %s", return_type, func_name),
              " * @param param_name - Description", -- Placeholder for params
              " * @return ReturnType - Description", -- Placeholder for return type
              " */",
            }
          end
        end
        return nil
      end

      -- Custom function to generate comments for an entire file
      local function comment_entire_file()
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local lang = vim.bo.filetype -- Detect the filetype
        local commented_lines = {}

        for _, line in ipairs(lines) do
          if line:match "^class" then
            local class_name = line:match "class%s+(%w+)"
            if class_name then
              table.insert(commented_lines, "/**")
              table.insert(commented_lines, string.format(" * Class %s", class_name))
              table.insert(commented_lines, " *")
              table.insert(commented_lines, " */")
            end
          elseif line:match "^function" or line:match "^public" then
            local docblock = generate_docblock(line, lang)
            if docblock then
              for _, block_line in ipairs(docblock) do
                table.insert(commented_lines, block_line)
              end
            end
          end
          table.insert(commented_lines, line)
        end

        vim.api.nvim_buf_set_lines(0, 0, -1, false, commented_lines)
      end
      -- Custom function to generate a file header
      local function add_file_header()
        -- Header block with placeholders
        local header = {
          "/**",
          " * @file <filename>", -- Placeholder for the filename
          " * @brief Brief description of the file",
          " *",
          " * @author Your Name",
          " * @date " .. os.date "%Y-%m-%d",
          " * @license MIT (or specify your license)",
          " */",
          "",
        }

        -- Insert the header at the top of the file
        vim.api.nvim_buf_set_lines(0, 0, 0, false, header)
      end

      -- Function to comment the entire file (including header)
      local function comment_entire_file_with_header()
        add_file_header() -- Add the header first
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local lang = vim.bo.filetype -- Detect the filetype
        local commented_lines = {}

        for _, line in ipairs(lines) do
          if line:match "^class" then
            local class_name = line:match "class%s+(%w+)"
            if class_name then
              table.insert(commented_lines, "/**")
              table.insert(commented_lines, string.format(" * Class %s", class_name))
              table.insert(commented_lines, " *")
              table.insert(commented_lines, " */")
            end
          elseif line:match "^function" or line:match "^public" then
            local docblock = generate_docblock(line, lang)
            if docblock then
              for _, block_line in ipairs(docblock) do
                table.insert(commented_lines, block_line)
              end
            end
          end
          table.insert(commented_lines, line)
        end

        vim.api.nvim_buf_set_lines(0, 0, -1, false, commented_lines)
      end

      -- Keybinding for adding a file header
      vim.keymap.set("n", "<leader>lh", add_file_header, { noremap = true, silent = true })

      -- Mapping <leader>lcf to comment entire file
      vim.keymap.set("n", "<leader>lcf", comment_entire_file, { noremap = true, silent = true })
      -- Optional: Keybinding for generating comments
      vim.keymap.set("n", "<leader>nc", ":Neogen<CR>", { silent = true, noremap = true, desc = "Generate Doc Comment" })
    end,
    cmd = "Neogen" , -- Lazy-load the plugin when `:Neogen` is called
  },
}
