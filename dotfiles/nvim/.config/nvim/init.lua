require('config.base')
require('config.keymaps')
require('config.lazy')

vim.cmd([[colorscheme kanagawa]])

vim.api.nvim_create_user_command('LspNvim', function()
  vim.lsp.enable('nvimls')
end, {})
