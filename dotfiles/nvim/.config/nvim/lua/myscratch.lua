local M = {}

local function create_and_fill_buffer(lines, type)
  local filetype = type or "text"
  local buf = vim.api.nvim_create_buf(true, false)
  vim.cmd('enew')
  vim.api.nvim_win_set_buf(0, buf)

  vim.bo[buf].bufhidden = 'delete'
  vim.bo[buf].filetype = filetype
  vim.bo[buf].swapfile = false

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end

local function evaluate_and_show(opts)
  -- Get the Lua code from command arguments
  local lua_code = opts.args or ""

  -- Evaluate the Lua code and capture output
  local success, result = pcall(function()
    -- Use loadstring to evaluate the code and capture print output
    local output = {}
    local original_print = print
    print = function(...)
      local args = {...}
      table.insert(output, table.concat(args, "\t"))
      original_print(...)
    end

    -- Load and execute the code
    local func, err = loadstring("return " .. lua_code)
    if not func then
      func, err = loadstring(lua_code)
    end

    if func then
      local exec_result = func()
      if exec_result ~= nil then
        table.insert(output, tostring(exec_result))
      end
    else
      table.insert(output, "Error: " .. err)
    end

    -- Restore original print
    print = original_print

    return output
  end)

  -- Prepare lines for buffer
  local lines = { }

  -- Add results
  if success then
    if #result > 0 then
      for _, line in ipairs(result) do
        table.insert(lines, line)
      end
      create_and_fill_buffer(lines, 'text')
    else
      table.insert(lines, "(no output)")
    end
  else
    table.insert(lines, "Error: " .. tostring(result))
  end
end

M.setup = function ()
  vim.api.nvim_create_user_command('MyScratch', evaluate_and_show, {
    nargs = 2,           -- Requires exactly one argument
    complete = 'expression',  -- Enable expression completion
    desc = 'Evaluate Lua code and show output in scratch buffer'
  })
end

return M
