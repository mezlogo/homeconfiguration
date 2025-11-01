require('config.base')
require('config.keymaps')
require('config.lazy')
require('config.detectkotlin')

local enable_lsp = vim.g.enable_lsp

if enable_lsp then
  vim.lsp.enable(enable_lsp)
end

-- find first file with given extension e.g. ".java" and open it in a buffer
local function find_and_open(extension)
  local file = vim.fn.glob("**/*" .. extension, nil, true)[1]
  if file then
    vim.cmd("e " .. file)
  else
    print("Can not find any file with given extension: " .. extension)
  end
end

local open_ft = vim.g.open_ft
if open_ft then
  find_and_open(open_ft)
end

vim.cmd([[colorscheme kanagawa]])

-- vim.api.nvim_create_user_command('LspNvim', function()
--   vim.lsp.enable('nvimls')
-- end, {})

-- vim.lsp.enable('jinja_lsp')
-- vim.lsp.enable('kotlin_lsp')
vim.lsp.enable('nvimls')
