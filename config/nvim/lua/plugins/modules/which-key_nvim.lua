--[[  folke/which-key.nvim

when creating mappings by calling `register({mappings},{opts})`, these are the defaults for opts:

  {
    mode = 'n',                 -- NORMAL mode
    -- prefix: use '<leader>f' for example for mapping everything related to finding files
    -- the prefix is prepended to every mapping part of `mappings`
    prefix = '<leader>',
    -- Global mappings. Specify a buffer number for buffer local mappings
    buffer = nil,
    -- use `silent` when creating keymaps
    silent = true,
    -- use `noremap` when creating keymaps
    noremap = true,
    -- use `nowait` when creating keymaps
    nowait = false,
    -- use `expr` when creating keymaps
    expr = false,
  },
]]
--

return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,

  config = function()
    local wk = require('which-key')
    wk.setup({
      window = {
        -- none, single, double, shadow, rounded
        border = 'rounded',
        -- bottom, top
        position = 'bottom',
        -- extra window margin [top, right, bottom, left]. When between 0 and 1, will be treated as a percentage of the screen size.
        margin = { 1, 0, 1, 0 },
        -- extra window padding [top, right, bottom, left]
        padding = { 1, 2, 1, 2 },
        -- value between 0-100 0 for fully opaque and 100 for fully transparent
        winblend = 5,
        -- positive value to position WhichKey above other floating windows.
        zindex = 1000,
      },
    })

    wk.register({
      -- to invoke: <leader> + group key ('f') + keymap ('t,f,g,e,r')
      prefix = '<leader>',
      f = {
        name = 'files',
        t = { '<cmd>Telescope find_files<cr>', 'Find Files' },
        f = { '<cmd>Telescope oldfiles<cr>', 'Recent Files', noremap = false },
        g = { '<cmd>Telescope git_files<cr>', 'Git ls-files' },
        e = { '<cmd>Telescope grep_string<cr>', 'Grep String' },
        r = { '<cmd>Telescope live_grep<cr>', 'Ripgep String' },
      },
    })

    wk.register({
      g = {
        name = "Go to",
        d = { vim.lsp.buf.definition, "Go to definition" },
        r = { require("telescope.builtin").lsp_references,
          "Open a telescope window with references" },
      },
    })

    wk.register({
      prefix = '<leader>',
      q = {
        name = 'codi.nvim',
        q = { '<cmd>Codi!! python<cr>', 'Codi Toggle Python' },
        r = { '<cmd>Codi!! irb<cr>', 'Codi Toggle Ruby' },
        w = { '<cmd>CodiSelect<cr>', 'Codi Scratch Buffer' },
        e = { '<cmd>CodiExpand<cr>', 'Codi Expand Popup' },
      },
    })

    wk.register({
      prefix = '<Leader>',
      t = {
        name = 'Neotree',
        t = { '<cmd>Neotree<cr>', 'Open Neotree in a sidebar' },
        h = { '<cmd>Neotree ~', 'Open Neotree from home folder'},
      }
    })
  end,
}
