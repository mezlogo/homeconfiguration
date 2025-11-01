---@return string|nil path to the eclipse-formatter.xml in recursive search from cwd
local function find_eclipse_formatter_xml()
  local target = "eclipse-formatter.xml"

  local cwd = vim.fn.getcwd()
  if not cwd or cwd == "" then
    return nil
  end

  local path = vim.fs.find(function(name, _)
    return name == target
  end, { path = cwd, type = "file" })

  if #path == 0 then
    return nil
  end

  return path[1]
end

--- Bind nvim-jdtls functions for testing
--- test class, test method, generate test, go to test, go to subject
local function set_jdtls_test_keymap()
  local opts = { noremap = true, silent = true }

  -- 1. Run entire test class
  vim.keymap.set("n", "<leader>tc", function()
    require("jdtls").test_class()
  end, opts)

  -- 2. Run current test method
  vim.keymap.set("n", "<leader>tm", function()
    require("jdtls").test_nearest_method()
  end, opts)

  -- 3. Generate test file
  vim.keymap.set("n", "<leader>tg", function()
    require("jdtls.tests").generate()
  end, opts)

  -- 4. Go to subject (implementation under test) from test file
  vim.keymap.set("n", "<leader>gs", function()
    require("jdtls").goto_super_method()
  end, opts)

  -- 5. Go to test file from subject (or vice versa)
  vim.keymap.set("n", "<leader>gt", function()
    require("jdtls.tests").goto_subjects()
  end, opts)
end

local function get_bundles()
  local java_debug_path = vim.fn.stdpath('data') .. '/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar'

  local bundles = {
    java_debug_path,
  }

  local java_test_path = vim.fn.stdpath('data') .. '/mason/share/java-test/*.jar'
  local java_test_bundles = vim.split(vim.fn.glob(java_test_path), "\n")
  local excluded = {
    "com.microsoft.java.test.runner-jar-with-dependencies.jar",
    "jacocoagent.jar",
  }


  for _, java_test_jar in ipairs(java_test_bundles) do
    local fname = vim.fn.fnamemodify(java_test_jar, ":t")
    if not vim.tbl_contains(excluded, fname) then
      table.insert(bundles, java_test_jar)
    end
  end

  return bundles
end

--- Creates a project-specific jdtls index/cache directory path in the user's cache directory.
---@param root_dir string The root directory of the Java project.
---@return string The full path to the jdtls cache directory for this project.
local function get_jdtls_cache_dir(root_dir)
  -- Use XDG_CACHE_HOME if set, otherwise default to ~/.cache
  local xdg_cache = os.getenv("XDG_CACHE_HOME")
  local cache_home = xdg_cache and xdg_cache ~= "" and xdg_cache
  or (os.getenv("HOME") and os.getenv("HOME") .. "/.cache")

  if not cache_home then
    error("Could not determine cache directory: $HOME is not set")
  end

  -- Normalize root_dir to avoid issues with trailing slashes
  root_dir = vim.fs.normalize(root_dir)

  local project_name = vim.fn.fnamemodify(root_dir, ":t")
  project_name = vim.fn.substitute(project_name, "[^a-zA-Z0-9._-]", "_", "g")

  local jdtls_dir = cache_home .. "/jdtls/" .. project_name
  return jdtls_dir
end


local function main()
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
  local jdtls_cache_dir = get_jdtls_cache_dir(project_name)
  local formatter_path = find_eclipse_formatter_xml()

  local config = {
    name = "jdtls",

    -- `cmd` defines the executable to launch eclipse.jdt.ls.
    -- `jdtls` must be available in $PATH and you must have Python3.9 for this to work.
    --
    -- As alternative you could also avoid the `jdtls` wrapper and launch
    -- eclipse.jdt.ls via the `java` executable
    -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line

    cmd = {
      "jdtls",
      "-data", jdtls_cache_dir,
    },


    -- `root_dir` must point to the root of your project.
    -- See `:help vim.fs.root`
    root_dir = vim.fs.root(0, { 'gradlew', 'mvnw', 'settings.gradle', 'settings.gradle.kts', 'pom.xml' }),


    -- Here you can configure eclipse.jdt.ls specific settings
    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    -- for a list of options
    settings = {
      java = {
        updateBuildConfiguration = "interactive",
        format = {
          enabled = false,
          settings = {
            url = 'file:///home/mezlogo/google-formatter-eclipse.xml',
            profile = 'GoogleStyle',
          }
        }
      }
    },


    -- This sets the `initializationOptions` sent to the language server
    -- If you plan on using additional eclipse.jdt.ls plugins like java-debug
    -- you'll need to set the `bundles`
    --
    -- See https://codeberg.org/mfussenegger/nvim-jdtls#java-debug-installation
    --
    -- If you don't plan on any eclipse.jdt.ls plugins you can remove this
    init_options = {
      bundles = get_bundles()
    },
    on_attach = function()
      set_jdtls_test_keymap()
    end,
  }

  require('jdtls').start_or_attach(config)
end

local function fixIndent()
  vim.opt.tabstop = 2
  vim.opt.softtabstop = 2
  vim.opt.shiftwidth = 2
  vim.opt.expandtab = true
  vim.opt.autoindent = true
  vim.opt.smartindent = true
end

main()
fixIndent()
