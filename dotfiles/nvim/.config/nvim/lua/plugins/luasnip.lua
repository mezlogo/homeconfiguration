-- local modes = { "i", "s" }

return {
  "L3MON4D3/LuaSnip",
  -- follow latest release.
  version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
  -- install jsregexp (optional!).
  build = "make install_jsregexp",
  -- keys = {
  --   { "<C-k>", function() require("luasnip").expand() end, mode = modes, desc = "Expand snippet" },
  --   { "<C-j>", function() require("luasnip").jump(1) end, mode = modes, desc = "Jump forward" },
  --   { "<C-h>", function() require("luasnip").jump(-1) end, mode = modes, desc = "Jump backward" },
    -- { "<C-l>", function() require("luasnip").choice_active() and require("luasnip").change_choice(1) end, desc = "Next choice" },
    -- { "<C-S-l>", function() require("luasnip").choice_active() and require("luasnip").change_choice(-1) end, desc = "Prev choice" },
    -- { "<C-e>", function() require("luasnip").unlink_current() end, desc = "Clear snippet" },
    -- { "<Tab>", function() require("luasnip").expand_or_jump() end, mode = "i", desc = "Expand or jump" },
    -- { "<S-Tab>", function() require("luasnip").jump(-1) end, mode = "i", desc = "Jump backward" },
    -- { "<C-n>", function() require("luasnip").available(1) and require("luasnip").expand_or_jump() end, mode = "i", desc = "Next snippet" },
    -- { "<C-p>", function() require("luasnip").available(-1) and require("luasnip").jump(-1) end, mode = "i", desc = "Prev snippet" },
  -- },
}
