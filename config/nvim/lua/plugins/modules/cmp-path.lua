return {
  'hrsh7th/cmp-path',
  config = function()
    require('cmp').setup({
      sources = {
        { name = 'path' },
      },
    })
  end
}
