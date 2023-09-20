return {
  'saadparwaiz1/cmp_luasnip',

  dependencies = {
    'L3MON4D3/LuaSnip',
  },

  config = function ()
    require('cmp').setup({
      sources = {
        { name = 'luasnip' },
      },
    })
  end
}
