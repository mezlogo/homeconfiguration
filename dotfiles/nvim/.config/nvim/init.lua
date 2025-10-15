require('config.base')
require('config.keymaps')
require('config.lazy')
require('config.detectkotlin')

vim.cmd([[colorscheme kanagawa]])

-- vim.api.nvim_create_user_command('LspNvim', function()
--   vim.lsp.enable('nvimls')
-- end, {})

vim.lsp.enable('jinja_lsp')
vim.lsp.enable('kotlin_lsp')
vim.lsp.enable('nvimls')
