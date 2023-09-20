return {
  'hrsh7th/cmp-cmdline',
  config = function()
    require('cmp').setup({
      sources = {
        { name = 'cmdline' },
      },
    })
  end
}
