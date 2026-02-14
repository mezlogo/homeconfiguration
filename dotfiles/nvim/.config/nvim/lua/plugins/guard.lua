return {
  "nvimdev/guard.nvim",
  config = function()
    local ft = require("guard.filetype")
    ft("json"):fmt({
      cmd = 'jq',
      stdin = true
    })

    vim.keymap.set('n', '<leader>F', ':Guard fmt<CR>')
  end
}
