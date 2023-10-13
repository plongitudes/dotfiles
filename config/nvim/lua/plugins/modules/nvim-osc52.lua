return {
  'ojroques/nvim-osc52',
  lazy = false,
  config = function()
    require('osc52').setup({
      max_length = 0,
      silent = false,
      trim = false,
    })
  end,
}
