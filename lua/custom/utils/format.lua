local M = {}

M.register = function(...)
  require("lazyvim.util.format").register(...)
end

M.resolve = function(...)
  return require("lazyvim.util.format").resolve(...)
end

---@param opts? {force?:boolean, buf?:number}
M.format = function(opts)
  opts = opts or {}
  local buf = opts.buf or vim.api.nvim_get_current_buf()
  if not ((opts and opts.force) or M.enabled(buf)) then
    return
  end

  local done = false
  -- ASYNC FORMAT START
  local run_async_formatters = function(formatters)
    local function run_next(index)
      if index > #formatters then
        return
      end
      local formatter = formatters[index]
      if formatter.active then
        done = true
        LazyVim.try(function()
          return formatter.format(buf, function()
            run_next(index + 1)
          end)
        end, { msg = "Formatter `" .. formatter.name .. "` failed" })
      else
        run_next(index + 1)
      end
    end
    run_next(1)
  end
  run_async_formatters(M.resolve(buf))
  -- ASYNC FORMAT END

  -- SYNC FORMAT START
  -- for _, formatter in ipairs(M.resolve(buf)) do
  --   if formatter.active then
  --     done = true
  --     LazyVim.try(function()
  --       return formatter.format(buf)
  --     end, { msg = "Formatter `" .. formatter.name .. "` failed" })
  --   end
  -- end
  -- SYNC FORMAT END

  if not done and opts and opts.force then
    LazyVim.warn("No formatter available", { title = "LazyVim" })
  end
end

M.info = function(...)
  require("lazyvim.util.format").info(...)
end

M.setup = function()
  -- NOTE: uncomment if you want Autoformat
  -- vim.api.nvim_create_autocmd("BufWritePre", {
  --   group = vim.api.nvim_create_augroup("LazyFormat", {}),
  --   callback = function(event)
  --     M.format({ buf = event.buf })
  --   end,
  -- })

  -- Manual format
  vim.api.nvim_create_user_command("LazyFormat", function()
    M.format { force = true }
  end, { desc = "Format selection or buffer" })

  -- Format info
  vim.api.nvim_create_user_command("LazyFormatInfo", function()
    M.info()
  end, { desc = "Show info about the formatters for the current buffer" })
end

return M
