return {
  'L3MON4D3/LuaSnip',
  dependencies = {
    "rafamadriz/friendly-snippets"
  },
  config = function()
    require("luasnip").setup({
      -- follow latest release.
      -- Replace <CurrentMajor> by the latest released major (first number of latest release)
      version = "2.*",
      -- install jsregexp (optional!).
      build = "make install_jsregexp"
    })
    require'luasnip'.filetype_extend("ruby", {"rails"})
  end
}
