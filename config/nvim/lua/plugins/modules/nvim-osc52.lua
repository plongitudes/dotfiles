local function copy(lines, _)
  require('osc52').copy(table.concat(lines, '\n'))
end

local function paste()
  return {vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('')}
end

vim.g.clipboard = {
  name = 'osc52',
  copy = {['+'] = copy, ['*'] = copy},
  paste = {['+'] = paste, ['*'] = paste},
}

-- Now the '+' register will copy to system clipboard using OSC52
--vim.keymap.set('n', '<leader>c', '"+y')
--vim.keymap.set('n', '<leader>cc', '"+yy')
vim.keymap.set('n', 'y', '"+y', {noremap = true,})
vim.keymap.set('n', 'yy', '"+yy', {noremap = true,})

return {
  'ojroques/nvim-osc52',
  lazy = false,
  enabled = true,
  config = function()
    require('osc52').setup({
      max_length = 0,
      silent = false,
      trim = false,
      tmux_passthrough = true,
    })
  end,
}
