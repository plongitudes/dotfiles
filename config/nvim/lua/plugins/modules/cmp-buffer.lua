return {
  'hrsh7th/cmp-buffer',
  config = function()
    require('cmp').setup({
      sources = {
        { name = 'buffer' },
      },
    })
  end
}
