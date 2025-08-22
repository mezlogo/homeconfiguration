local function config_nvim_jdtls()
  local HOME = vim.env.HOME
  --
  -- If you started neovim within `~/dev/xy/project-1` this would resolve to `project-1`
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
  local workspace_dir = HOME .. '/.local/state/jdtls_workspace' .. project_name

  local config = {
    cmd = {
      HOME .. '/tools/jdtls/bin/jdtls',
      '-configuration', HOME .. '/.cache/jdtls',
      '-data', workspace_dir,
    },
    root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),
  }

  local jdtls = require('jdtls')
  jdtls.start_or_attach(config)
end

return {
  'mfussenegger/nvim-jdtls',
  lazy = true,
  enabled = false,
  ft = 'java',
  config = config_nvim_jdtls,
}
